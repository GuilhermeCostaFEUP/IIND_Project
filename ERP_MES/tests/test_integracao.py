# integration_test_capacity.py

import socket
import json
import threading
import time

ERP_HOST = "127.0.0.1"
ERP_PORT = 5666
BUFFER_SIZE = 4096

# Timeouts
TIMEOUT_ACK      = 5   # para ack do ERP
TIMEOUT_FEEDBACK = 100  # para feedback do MES

# Pedidos de teste:
# - OrderID 0: 12 peças
# - OrderID 1: 8 peças  (total = 20)
# - OrderID 2: 4 peças  (total = 24)
# - OrderID 3: 1 peça   (total = 25 → excede limite de 24)
TEST_ORDERS = [
    {"name":"ClienteX","NIF":123,"OrderID":0,"orders":[{"type":5,"quantity":12,"DDate":1,"Penalty":0}]},
    {"name":"ClienteX","NIF":123,"OrderID":1,"orders":[{"type":6,"quantity":8, "DDate":1,"Penalty":30}]},
    {"name":"ClienteX","NIF":123,"OrderID":2,"orders":[{"type":7,"quantity":4, "DDate":1,"Penalty":20}]},
    {"name":"ClienteX","NIF":123,"OrderID":3,"orders":[{"type":9,"quantity":1, "DDate":1,"Penalty":10}]}
]

def test_order(order):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(TIMEOUT_ACK)

    payload = json.dumps(order).encode('utf-8')
    print(f"[Client] Sending OrderID={order['OrderID']} ({sum(o['quantity'] for o in order['orders'])} pcs)")
    sock.sendto(payload, (ERP_HOST, ERP_PORT))

    # 1) ack do ERP
    try:
        data, _ = sock.recvfrom(BUFFER_SIZE)
        print(f"[Client] ERP ack OrderID={order['OrderID']}: {data.decode()}")
    except socket.timeout:
        print(f"[Client] No ERP ack OrderID={order['OrderID']} (timeout)")

    # 2) feedback do MES
    sock.settimeout(TIMEOUT_FEEDBACK)
    try:
        data, _ = sock.recvfrom(BUFFER_SIZE)
        print(f"[Client] MES feedback OrderID={order['OrderID']}: {data.decode()}")
    except socket.timeout:
        print(f"[Client] MES rejected OrderID={order['OrderID']} (no feedback within {TIMEOUT_FEEDBACK}s)")

    sock.close()

# dispara em sequência rápida para cair no mesmo batch
threads = []
for o in TEST_ORDERS:
    t = threading.Thread(target=test_order, args=(o,))
    t.start()
    threads.append(t)
    time.sleep(0.2)  # spacing < batch window

for t in threads:
    t.join()

print("Capacity integration test complete.")
