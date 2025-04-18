# multi_mes_priorities_test.py

import socket
import json
import time

MES_HOST = "127.0.0.1"
MES_PORT = 5667
BUFFER_SIZE = 4096
TOTAL_TIMEOUT = 20  # Tempo máximo em segundos para receber todos os feedbacks

# Conjunto de ordens com diferentes DDate, Penalty e quantidades
TEST_ORDERS = [
    # Baixa prioridade (DDate alto)
    {"name": "T", "NIF": 1, "OrderID": 10, "orders": [{"type": 5, "quantity": 1, "DDate": 5, "Penalty": 0}]},
    # Média prioridade, sem penalty
    {"name": "T", "NIF": 1, "OrderID": 11, "orders": [{"type": 5, "quantity": 1, "DDate": 2, "Penalty": 0}]},
    # Média prioridade, penalty alto
    {"name": "T", "NIF": 1, "OrderID": 12, "orders": [{"type": 5, "quantity": 1, "DDate": 2, "Penalty": 10}]},
    # Média prioridade, penalty médio
    {"name": "T", "NIF": 1, "OrderID": 13, "orders": [{"type": 5, "quantity": 1, "DDate": 2, "Penalty": 5}]},
    # Altíssima prioridade
    {"name": "T", "NIF": 1, "OrderID": 14, "orders": [{"type": 5, "quantity": 1, "DDate": 1, "Penalty": 1}]},
    # Teste de multi-doca
    {"name": "T", "NIF": 1, "OrderID": 20, "orders": [{"type": 5, "quantity": 7, "DDate": 2, "Penalty": 0}]}
]

# Cria socket UDP e liga a porta local (ephemeral)
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', 0))
sock.settimeout(1.0)

print("=== Enviando ordens de teste ao MES ===")
for o in TEST_ORDERS:
    sock.sendto(json.dumps(o).encode('utf-8'), (MES_HOST, MES_PORT))
    od = o['orders'][0]
    print(f"  -> OrderID={o['OrderID']} (DDate={od['DDate']}, Penalty={od['Penalty']}, qty={od['quantity']})")

print("\n=== Aguardando feedback (até 20s) ===")
received = []
start = time.time()
while len(received) < len(TEST_ORDERS) and (time.time() - start) < TOTAL_TIMEOUT:
    try:
        data, _ = sock.recvfrom(BUFFER_SIZE)
        j = json.loads(data)
        received.append(j)
        print(f"[{len(received)}] Feedback: OrderID={j['OrderID']}, docks={j['assignedDocks']}, cost={j['estimatedCost']}")
    except socket.timeout:
        continue

print("\n=== Resumo da ordem de processamento ===")
for idx, j in enumerate(received, 1):
    print(f"{idx}. OrderID={j['OrderID']}")

sock.close()
