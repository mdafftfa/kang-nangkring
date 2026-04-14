#!/bin/bash

if [ -f .env ]; then
    echo "--- Memuat konfigurasi dari .env ---"
    export $(grep -v '^#' .env | xargs)
else
    echo "--- PERINGATAN: File .env tidak ditemukan! ---"
fi

if ! command -v dotnet &> /dev/null || [[ "$(dotnet --version)" != 10.* ]]; then
    echo "--- .NET 10 tidak ditemukan. Mengunduh installer... ---"
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
    
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$HOME/.dotnet
fi

PUBLISH_DIR="publish"
PROJECT_NAME="kang-nangkring.dll"

echo "--- Memulai proses Build & Publish (R2R Composite + PGO) ---"

dotnet publish -c Release -r linux-x64 --self-contained false -o $PUBLISH_DIR

if [ -f "$PUBLISH_DIR/$PROJECT_NAME" ]; then
    echo "--- Aplikasi siap. Menjalankan $PROJECT_NAME ---"
    echo "--- Mode: R2R Composite & Tiered PGO Aktif ---"
  
    dotnet "$PUBLISH_DIR/$PROJECT_NAME"
else
    echo "Gagal menemukan $PROJECT_NAME di folder $PUBLISH_DIR"
    exit 1
fi