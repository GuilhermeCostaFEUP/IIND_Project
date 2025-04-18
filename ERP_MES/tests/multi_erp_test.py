# multi_mes_test.py

import socket
import json
import threading

ERP_HOST = "127.0.0.1"
ERP_PORT = 5666
BUFFER_SIZE = 4096
TIMEOUT = 2.0  # segundos de espera por cada resposta

# Lista de pedidos de teste
TEST_ORDERS = [
    {
        "name": f"Cliente{i}",
        "NIF": 100000000 + i,
        "OrderID": i,
        "orders": [
            {"type": 5, "quantity": i+1, "DDate": 3, "Penalty": 10 * i},
            {"type": 9, "quantity": (i % 3) + 1, "DDate": 1, "Penalty": 5 * i}
        ]
    }
    for i in range(5)
]

def test_order(order):
    """Envia um pedido ao ERP e aguarda resposta do ERP e feedback do MES."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(TIMEOUT)

    # Envio do JSON ao ERP
    payload = json.dumps(order).encode('utf-8')
    sock.sendto(payload, (ERP_HOST, ERP_PORT))
    print(f"[Order {order['OrderID']}] Enviado ao ERP")

    # 1) Receber confirmação do ERP
    try:
        resp_erp, _ = sock.recvfrom(BUFFER_SIZE)
        print(f"[Order {order['OrderID']}] Resposta ERP: {resp_erp.decode()}")
    except socket.timeout:
        print(f"[Order {order['OrderID']}] Sem resposta do ERP (timeout)")

    # 2) Receber feedback do MES
    try:
        resp_mes, _ = sock.recvfrom(BUFFER_SIZE)
        print(f"[Order {order['OrderID']}] Resposta MES: {resp_mes.decode()}")
    except socket.timeout:
        print(f"[Order {order['OrderID']}] Sem resposta do MES (timeout)")

    sock.close()

# Dispara threads para envio concorrente
threads = []
for order in TEST_ORDERS:
    t = threading.Thread(target=test_order, args=(order,))
    threads.append(t)
    t.start()

# Aguardar conclusão de todas as threads
for t in threads:
    t.join()

print("Teste MES completo.")
