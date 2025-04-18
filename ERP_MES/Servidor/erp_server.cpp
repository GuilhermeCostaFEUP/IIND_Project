// erp.cpp
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <iostream>
#include <string>
#include <unordered_map>
#include "../includes/json.hpp"

#pragma comment(lib, "ws2_32.lib")
using json = nlohmann::json;

constexpr int ERP_PORT = 5666;
constexpr int MES_PORT = 5667;
constexpr int BUF_SZ   = 4096;

// Map OrderID → original client address
static std::unordered_map<int, sockaddr_in> clientMap;

// Validate client order JSON
bool validateClientOrder(const json &j, std::string &err) {
    if (!j.contains("name")    || !j["name"].is_string())        err += "name ausente/inválido; ";
    if (!j.contains("NIF")     || !j["NIF"].is_number_integer()) err += "NIF ausente/inválido; ";
    if (!j.contains("OrderID") || !j["OrderID"].is_number_integer()) err += "OrderID ausente/inválido; ";
    if (!j.contains("orders")  || !j["orders"].is_array())       { err += "orders ausente/inválido; "; return false; }
    for (auto &it : j["orders"]) {
        if (!it.contains("type")    || !it["type"].is_number_integer())    err += "type ausente/inválido; ";
        if (!it.contains("quantity")|| !it["quantity"].is_number_integer())err += "quantity ausente/inválido; ";
        if (!it.contains("DDate")   || !it["DDate"].is_number_integer())   err += "DDate ausente/inválido; ";
        if (!it.contains("Penalty") || !it["Penalty"].is_number_integer()) err += "Penalty ausente/inválido; ";
        int t = it["type"];
        if (t!=5 && t!=6 && t!=7 && t!=9)                                  err += "type deve ser 5,6,7 ou 9; ";
    }
    return err.empty();
}

int main() {
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2,2), &wsa) != 0) {
        std::cerr << "WSAStartup falhou\n";
        return 1;
    }

    SOCKET sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    sockaddr_in erpAddr{};
    erpAddr.sin_family      = AF_INET;
    erpAddr.sin_addr.s_addr = INADDR_ANY;
    erpAddr.sin_port        = htons(ERP_PORT);
    if (bind(sock, (sockaddr*)&erpAddr, sizeof(erpAddr)) == SOCKET_ERROR) {
        std::cerr << "bind ERP falhou: " << WSAGetLastError() << "\n";
        return 1;
    }

    // MES address
    sockaddr_in mesAddr{};
    mesAddr.sin_family = AF_INET;
    inet_pton(AF_INET, "127.0.0.1", &mesAddr.sin_addr);
    mesAddr.sin_port = htons(MES_PORT);

    char buf[BUF_SZ];
    sockaddr_in cli;
    int cliLen = sizeof(cli);

    std::cout << "ERP listening on UDP/" << ERP_PORT << "...\n";

    while (true) {
        int n = recvfrom(sock, buf, BUF_SZ-1, 0, (sockaddr*)&cli, &cliLen);
        if (n <= 0) continue;
        buf[n] = '\0';

        json j;
        try {
            j = json::parse(buf);
        } catch (...) {
            // ignore non-JSON
            continue;
        }

        // If it's a new client order
        if (j.contains("name") && j.contains("orders")) {
            int oid = j["OrderID"];
            clientMap[oid] = cli;

            std::string err;
            if (validateClientOrder(j, err)) {
                // Acknowledge to client
                std::string ok = "OK: Pedido válido.";
                sendto(sock, ok.c_str(), ok.size(), 0, (sockaddr*)&cli, cliLen);

                // Forward to MES
                sendto(sock, buf, n, 0, (sockaddr*)&mesAddr, sizeof(mesAddr));
                std::cout << "ERP->MES forward OrderID=" << oid << "\n";
            } else {
                std::string er = "ERRO: " + err;
                sendto(sock, er.c_str(), er.size(), 0, (sockaddr*)&cli, cliLen);
                std::cerr << er << "\n";
            }

        // If it's feedback from MES
        } else if (j.contains("assignedDocks")) {
            int oid = j["OrderID"];
            auto it = clientMap.find(oid);
            if (it != clientMap.end()) {
                // Send feedback back to original client
                sockaddr_in &c = it->second;
                sendto(sock, buf, n, 0, (sockaddr*)&c, sizeof(c));
                std::cout << "ERP->Client feedback OrderID=" << oid << "\n";
            }
        }
        // ignore any other messages
    }

    closesocket(sock);
    WSACleanup();
    return 0;
}
