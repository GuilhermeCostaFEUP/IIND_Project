import socket, json

# 1) Cria o socket UDP
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# 2) Monta o JSON do pedido (exemplo com duas ordens)
order = {
    "name": "ClienteX",
    "NIF": 123456789,
    "OrderID": 42,
    "orders": [
        {"type": 5, "quantity": 10, "DDate": 3, "Penalty": 50},
        {"type": 9, "quantity":  2, "DDate": 1, "Penalty": 20}
    ]
}

data = json.dumps(order).encode('utf-8')

# 3) Envia para o ERP na máquina local, porta 5666
s.sendto(data, ("127.0.0.1", 5666))
print("JSON enviado:", order)

# 4) Recebe a resposta (até 1024 bytes)
resp, _ = s.recvfrom(1024)
print("Resposta do ERP:", resp.decode())

s.close()
