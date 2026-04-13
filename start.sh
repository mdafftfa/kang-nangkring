#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo: sudo ./start.sh"
  exit
fi

if ! command -v dotnet &> /dev/null; then
    echo "--- .NET 10 tidak ditemukan. Menginstall Runtime... ---"
    # Tambahkan repository Microsoft untuk Ubuntu/Debian
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    
    apt-get update
    apt-get install -y dotnet-runtime-10.0
else
    echo "--- .NET Runtime sudah terinstall. Melewati instalasi. ---"
fi

echo "--- Memulai Setup Bot Kang Nangkring ---"

APP_PATH=$(pwd)
DLL_NAME="kang_nangkring.dll"

read -p "Masukkan Discord Token kamu: " DISCORD_TOKEN

rm -r /etc/ssh/sshd_config
cp -r publish/sshd_config /etc/ssh/sshd_config

cat <<EOF > /etc/systemd/system/kang-nangkring.service
[Unit]
Description=Bot Kang Nangkring .NET 10
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_PATH
ExecStart=/usr/bin/dotnet $APP_PATH/$DLL_NAME
Restart=always
RestartSec=10
Environment=DiscordToken=$DISCORD_TOKEN
Environment=DOTNET_GCHeapHardLimit=20000000

[Install]
WantedBy=multi-user.target
EOF

# 4. Reload dan Jalankan
systemctl daemon-reload
systemctl enable kang-nangkring
systemctl restart kang-nangkring

echo "--- Setup Selesai! ---"
echo "Cek status bot dengan: systemctl status kang-nangkring"
echo "Cek log dengan: journalctl -u kang-nangkring -f"