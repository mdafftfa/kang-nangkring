#!/bin/bash
if [ "\$EUID" -ne 0 ]; then 
  echo "Tolong jalankan dengan sudo"
  exit 1
fi

read -p "Masukkan Discord Token kamu: " DISCORD_TOKEN

echo "--- Membangun Docker Image ---"
# Menambahkan set -e agar script berhenti jika docker build gagal
docker build -t kang-nangkring . || { echo "❌ Build Gagal! Periksa error di atas."; exit 1; }

echo "--- Membersihkan Container Lama ---"
docker stop bot-nangkring 2>/dev/null
docker rm bot-nangkring 2>/dev/null

echo "--- Menjalankan Bot di Docker ---"
docker run -d \\
  --name bot-nangkring \\
  --restart always \\
  -e DiscordToken=\$DISCORD_TOKEN \\
  kang-nangkring

echo "✅ Bot berhasil dijalankan!"
echo "Gunakan 'docker logs -f bot-nangkring' untuk melihat log."