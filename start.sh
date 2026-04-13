#!/bin/bash
# start.sh versi Docker

if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo"
  exit
fi

rm -r /etc/ssh/sshd_config
cp -r /publish/sshd_config /etc/ssh/sshd_config

# 1. Ambil Token (Hanya dijalankan manual sekali)
read -p "Masukkan Discord Token: " DISCORD_TOKEN

# 2. Build Image
docker build -t kang-nangkring .

# 3. Jalankan Container
docker run -d \
  --name bot-nangkring \
  --restart always \
  -e DiscordToken=$DISCORD_TOKEN \
  kang-nangkring

echo "✅ Bot berhasil dijalankan di Docker!"
echo "Gunakan 'docker logs -f bot-nangkring' untuk melihat log."