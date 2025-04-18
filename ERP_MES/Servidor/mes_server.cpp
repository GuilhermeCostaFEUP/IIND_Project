// mes.cpp
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <iostream>
#include <queue>
#include <vector>
#include <mutex>
#include <thread>
#include <condition_variable>
#include "../includes/json.hpp"

#pragma comment(lib, "ws2_32.lib")
using json = nlohmann::json;

static constexpr int MES_PORT            = 5667;
static constexpr int BUF_SZ              = 4096;
static constexpr int NUM_DOCKS           = 4;
static constexpr int DOCK_CAPACITY       = 6;
static constexpr int BASE_COST_PER_PIECE = 10;
static constexpr int DAILY_MAX_PIECES    = 24;

// Job de produção
struct Job {
    int           orderID;
    std::string   clientName;
    int           NIF;
    int           DDate;
    int           Penalty;
    int           quantity;
    sockaddr_in   replyAddr;
};

// prioridade: menor DDate = maior prioridade; em empate, maior Penalty
struct Cmp {
    bool operator()(const Job &a, const Job &b) const {
        // retorna true se 'a' deve vir depois de 'b'
        if (a.DDate != b.DDate)
            return a.DDate > b.DDate;   // maior DDate = menor prioridade
        return a.Penalty < b.Penalty;   // menor Penalty = menor prioridade
    }
};

static std::priority_queue<Job, std::vector<Job>, Cmp> pq;
static std::mutex              pqMtx;
static std::condition_variable pqCv;
static int                     dailyTotal = 0;  // peças agendadas hoje

void scheduler() {
    WSADATA wsa;
    WSAStartup(MAKEWORD(2,2), &wsa);

    const std::chrono::seconds BATCH_WINDOW(2); // tempo de coleta de ordens
    while (true) {
        {
            std::unique_lock<std::mutex> lk(pqMtx);
            pqCv.wait(lk, []{ return !pq.empty(); });
        }
        std::this_thread::sleep_for(BATCH_WINDOW);

        while (true) {
            Job job;
            {
                std::unique_lock<std::mutex> lk(pqMtx);
                if (pq.empty()) break;
                job = pq.top(); pq.pop();
            }

            std::cout << "[MES] Processing OrderID=" << job.orderID
                      << " qty=" << job.quantity << "\n";
            Sleep(1000 * job.quantity); // 1s por peça

            static int nextDock = 0;
            int rem = job.quantity;
            std::vector<int> docks;
            while (rem > 0) {
                docks.push_back(nextDock);
                rem -= DOCK_CAPACITY;
                nextDock = (nextDock + 1) % NUM_DOCKS;
            }

            int cost = BASE_COST_PER_PIECE * job.quantity;
            json resp = {
                {"OrderID",       job.orderID},
                {"assignedDocks", docks},
                {"estimatedCost", cost}
            };
            std::string msg = resp.dump();

            SOCKET s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
            sendto(s, msg.c_str(), (int)msg.size(), 0,
                   (sockaddr*)&job.replyAddr, sizeof(job.replyAddr));
            closesocket(s);

            std::cout << "[MES] Feedback sent: " << msg << "\n";
        }

        // Reset daily total after processing batch (assume batch = one day)
        {
            std::lock_guard<std::mutex> lg(pqMtx);
            dailyTotal = 0;
            std::cout << "[MES] Daily total reset to 0 for next batch/day\n";
        }
    }
}

int main() {
    std::thread(scheduler).detach();

    WSADATA wsa;
    WSAStartup(MAKEWORD(2,2), &wsa);
    SOCKET sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    sockaddr_in addr{};
    addr.sin_family      = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port        = htons(MES_PORT);

    if (bind(sock, (sockaddr*)&addr, sizeof(addr)) == SOCKET_ERROR) {
        std::cerr << "bind MES falhou: " << WSAGetLastError() << "\n";
        return 1;
    }

    std::cout << "MES listening on UDP/" << MES_PORT << "\n";

    char buf[BUF_SZ];
    sockaddr_in cli;
    int cliLen = sizeof(cli);

    while (true) {
        int n = recvfrom(sock, buf, BUF_SZ-1, 0, (sockaddr*)&cli, &cliLen);
        if (n <= 0) continue;
        buf[n] = '\0';

        json j;
        try { j = json::parse(buf); }
        catch (...) { continue; }

        if (!j.contains("name") || !j.contains("NIF") ||
            !j.contains("OrderID")|| !j.contains("orders")) {
            std::cerr << "[MES] Pedido incompleto\n";
            continue;
        }

        int batchQty = 0;
        for (auto &it : j["orders"]) batchQty += it["quantity"].get<int>();

        {
            std::lock_guard<std::mutex> lg(pqMtx);
            if (dailyTotal + batchQty > DAILY_MAX_PIECES) {
                std::cerr << "[MES] Erro: capacidade diária excedida ao receber OrderID="
                          << j["OrderID"] << " (" << dailyTotal + batchQty
                          << " > " << DAILY_MAX_PIECES << ")\n";
                continue;
            }
            dailyTotal += batchQty;
        }

        for (auto &it : j["orders"]) {
            Job job;
            job.orderID   = j["OrderID"];
            job.clientName= j["name"];
            job.NIF       = j["NIF"];
            job.DDate     = it["DDate"];
            job.Penalty   = it["Penalty"];
            job.quantity  = it["quantity"];
            job.replyAddr = cli;

            {
                std::lock_guard<std::mutex> lg(pqMtx);
                pq.push(std::move(job));
            }
            pqCv.notify_one();
            std::cout << "[MES] Enqueued OrderID=" << j["OrderID"] << "\n";
        }
    }

    return 0;
}
