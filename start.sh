#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo"
  exit
fi

# 1. Install Docker jika belum ada
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# 2. Ambil Token
read -p "Masukkan Discord Token: " DISCORD_TOKEN

# 3. Build & Run
echo "Building Bot Container..."
docker build -t bot-nangkring .

echo "Running Bot..."
docker run -d \
  --name bot-nangkring \
  --restart always \
  -e DiscordToken=$DISCORD_TOKEN \
  bot-nangkring

echo "Selesai! Bot jalan di Docker."
echo "Cek log: docker logs -f bot-nangkring"