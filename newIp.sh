#!/bin/bash

# Исходный IP
ip=$1

# Функция для преобразования IP в 32-битное число
ip_to_int() {
    local ip=$1
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

# Функция для преобразования 32-битного числа обратно в IP
int_to_ip() {
    local int=$1
    echo "$((int >> 24 & 255)).$((int >> 16 & 255)).$((int >> 8 & 255)).$((int & 255))"
}

# Преобразуем IP в число
ip_int=$(ip_to_int "$ip")

# Увеличиваем число на 1
new_ip_int=$((ip_int + 1))

# Преобразуем обратно в IP
new_ip=$(int_to_ip "$new_ip_int")

# Выводим новый IP
echo "$new_ip"

