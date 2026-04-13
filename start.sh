#!/bin/bash
if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo"
  exit 1
fi

sudo apt-get install -y docker.io

read -p "Masukkan Discord Token kamu: " DISCORD_TOKEN

echo "--- Membangun Docker Image ---"
docker build -t kang-nangkring .

echo "--- Membersihkan Container Lama ---"
docker stop bot-nangkring
docker rm bot-nangkring

echo "--- Menjalankan Bot di Docker ---"
docker run -d \
  --name bot-nangkring \
  --restart always \
  --net=host \
  -e DiscordToken=$DISCORD_TOKEN \
  kang-nangkring

echo "✅ Bot berhasil dijalankan!"