#!/bin/bash
if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo"
  exit 1
fi

# 1. Tarik file hasil build (.dll) terbaru dari branch deploy
echo "--- Menarik Update dari GitHub (Branch Deploy) ---"
git pull origin deploy

# 2. Build image Docker (sangat cepat karena hanya COPY file saja)
echo "--- Mengupdate Docker Image ---"
docker build -t kang-nangkring .

# 3. Membersihkan Container lama
echo "--- Membersihkan Container Lama ---"
docker stop bot-nangkring 2>/dev/null
docker rm bot-nangkring 2>/dev/null

# 4. Input Token jika belum ada di environment
if [ -z "$DISCORD_TOKEN" ]; then
    read -p "Masukkan Discord Token kamu: " DISCORD_TOKEN
fi

# 5. Jalankan Bot
echo "--- Menjalankan Bot di Docker ---"
docker run -d \
  --name bot-nangkring \
  --restart always \
  --net=host \
  -e DiscordToken=$DISCORD_TOKEN \
  kang-nangkring