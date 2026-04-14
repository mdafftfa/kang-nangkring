# ☕ Kang Nangkring Bot (Discord)

Bot Discord sederhana 24/7 Nangkring di Voice Channel berbasis .NET untuk kebutuhan komunitas—ringan, cepat, dan cocok untuk pemula.

---

## 🚀 Cara Deploy (Linux Only)

Ikuti langkah ini dari awal sampai jalan:

### 1. Clone Repository

```bash
git clone https://github.com/mdafftfa/kang-nangkring
cd kang-nangkring
```

### 2. Jalankan Script

```bash
chmod +x start.sh
./start.sh
```

---

## 🔑 Masukkan Token Discord

Saat menjalankan `start.sh`, kamu akan diminta:

```
Masukkan Discord Token Anda:
```

➡️ Paste token bot Discord kamu di sini.

---

## ⚙️ Apa yang Script Lakukan?

Script `start.sh` akan otomatis:

* Cek apakah **.NET 10** sudah terinstall
* Jika belum → akan install otomatis
* Build project dengan optimasi:

  * ✅ ReadyToRun (lebih cepat start)
  * ✅ Tiered PGO (lebih optimal performa)
* Menjalankan bot langsung

---

## 📁 Struktur Singkat

```
kang-nangkring/
├── src/
│   └── kang-nangkring/
│       └── kang-nangkring.csproj
├── start.sh
└── README.md
```

---

## 🧠 Catatan Penting

* Bot menggunakan:

  * Gateway Discord
  * Application Commands (Slash Commands)
* Intent yang aktif:

  * Guilds
  * Voice States

---

## ❗ Troubleshooting

### .NET tidak terdeteksi

Tidak masalah — script akan install otomatis.

### Bot tidak jalan

Cek:

* Token benar atau tidak
* Bot sudah di-invite ke server
* Permission sudah sesuai

---

## 💡 Tips Pemula

* Gunakan VPS Linux (Ubuntu/Debian)
* Simpan token dengan aman (jangan di-upload ke GitHub)
* Restart bot kalau ada perubahan kode

---

## 🎯 Tujuan Project

Project ini dibuat biar:

* Mudah dipahami pemula
* Cepat langsung jalan
* Bisa jadi dasar belajar bot Discord pakai .NET

---

Selamat ngoding, lur! ☕