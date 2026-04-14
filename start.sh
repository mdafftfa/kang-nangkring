#!/bin/bash

# 1. Cek apakah .NET 10 sudah terinstall
if ! command -v dotnet &> /dev/null || [[ "$(dotnet --version)" != 10.* ]]; then
    echo "--- .NET 10 tidak ditemukan. Mengunduh installer... ---"
    # Menggunakan official install script dari Microsoft
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
    
    # Menambahkan dotnet ke PATH untuk sesi ini
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$HOME/.dotnet
fi

# 2. Menentukan folder output
PUBLISH_DIR="publish"
PROJECT_NAME="kang-nangkring.dll"

echo "--- Memulai proses Build & Publish (R2R Composite + PGO) ---"

# 3. Melakukan Publish
# --self-contained false: Menggunakan runtime yang ada (lebih cepat jika SDK sudah ada)
# -r: Runtime Identifier (sesuaikan linux-x64 jika menggunakan arsitektur lain)
# -c Release: Wajib untuk performa
dotnet publish -c Release -r linux-x64 --self-contained false -o $PUBLISH_DIR

# 4. Menjalankan aplikasi
if [ -f "$PUBLISH_DIR/$PROJECT_NAME" ]; then
    echo "--- Aplikasi siap. Menjalankan $PROJECT_NAME ---"
    echo "--- Mode: R2R Composite & Tiered PGO Aktif ---"
    
    # Menjalankan DLL dari folder publish
    dotnet "$PUBLISH_DIR/$PROJECT_NAME"
else
    echo "Gagal menemukan $PROJECT_NAME di folder $PUBLISH_DIR"
    exit 1
fi