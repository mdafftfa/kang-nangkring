#!/bin/bash
# start.sh versi Docker - CLEAN VERSION

if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo: sudo ./start.sh"
  exit
fi

# 1. Ambil Token
read -p "Masukkan Discord Token kamu: " DISCORD_TOKEN

# 2. Build Image
echo "--- Membangun Docker Image ---"
docker build -t kang-nangkring .

# 3. Hapus container lama jika ada
docker stop bot-nangkring 2>/dev/null
docker rm bot-nangkring 2>/dev/null

# 4. Jalankan Container
echo "--- Menjalankan Bot di Docker ---"
docker run -d \
  --name bot-nangkring \
  --restart always \
  -e DiscordToken=$DISCORD_TOKEN \
  kang-nangkring

echo "✅ Bot berhasil dijalankan!"
echo "Cek log dengan: docker logs -f bot-nangkring"