#!/usr/bin/bash
dir="PC_keys"
if [ ! -d "$dir" ]; then
  mkdir "$dir"
fi

cd "$dir"
pwd

if [ -z "$1" ]; then
  echo "Ошибка: Не указано имя."
  exit 1  # Выход из скрипта с кодом ошибки 1
fi

userName=$1
echo "$userName"

wg genkey | tee /etc/wireguard/"$dir"/"$userName"_privatekey | wg pubkey | tee /etc/wireguard/"$dir"/"$userName"_publickey

userPublicKey=$(cat "$userName"_publickey)
userPrivateKey=$(cat "$userName"_privatekey)
serverPublicKey=$(cat ../server_publickey)
echo "$userPublicKey"

cd ../
pwd

currentIP=$(cat current_ip)
echo "$currentIP"

currentMask=$(cat ip_mask)

textToServerConfig="
[Peer] #$userName pc
PublicKey = $userPublicKey
AllowedIPs = $currentIP"

echo "$textToServerConfig" >> wg0.conf


newIP=$(./newIp.sh "$currentIP")
> current_ip
echo "$newIP" >> current_ip

confDir="PC_confs"
if [ ! -d "$confDir" ]; then
  mkdir "$confDir"
fi

cd  "$confDir"

touch "$userName"_PC.conf

textConf="[Interface]
PrivateKey = $userPrivateKey
Address = $currentIP$currentMask
DNS = 8.8.8.8

[Peer]
PublicKey = $serverPublicKey
Endpoint = 31.130.153.64:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 20"

> "$userName"_PC.conf
echo "$textConf" >> "$userName"_PC.conf
echo "$tectConf"

systemctl restart wg-quick@wg0.service
