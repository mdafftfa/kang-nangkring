# 🤖 Kang Nangkring

Bot Discord sederhana 24/7 Nangkring di Voice Channel berbasis .NET Worker + [NetCord](https://github.com/NetCordDev/NetCord/).
Cocok untuk server komunitas, voice, dan automation ringan.

---

## 🚀 Fitur
- Connect ke Discord Gateway
- Support Application Commands
- Fokus Guild & Voice State
- Lightweight & optimized (R2R + PGO)

---

## 📦 Requirement
- Linux (Ubuntu / Debian / VPS / WSL)
- .NET 10 SDK / Runtime
- Git
- Curl

---

## 🔑 Setup Token Discord
Ambil token dari:
https://discord.com/developers/applications

Saat menjalankan bot nanti:
Masukkan Discord Token Anda:

---

## 📥 Cara Install & Run (Linux Only)

- git clone https://github.com/mdafftfa/kang-nangkring
- cd kang-nangkring
- chmod +x start.sh
- ./start.sh

---

## ⚙️ Cara Kerja Script

start.sh akan:
1. Minta input Discord Token
2. Set environment variable Discord__Token
3. Cek .NET 10 (auto install jika belum ada)
4. Build & publish project
5. Menjalankan bot

---

## 🧠 Catatan Penting

Intents yang dipakai:
- Guilds
- Voice States

Optimasi aktif:
- Tiered Compilation
- ReadyToRun (R2R Composite)
- PGO

---

## ❗ Troubleshooting

- Cek token Discord benar
- Pastikan internet aktif
- Pastikan .NET 10 terinstall

---

## 📜 License
Free untuk belajar & komunitas.