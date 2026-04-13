# Stage 1: Runtime
# Kita pakai image .NET 10 resmi dari Microsoft
FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS base
WORKDIR /app

# Stage 2: Copy hasil publish dari GitHub Actions
# Karena GitHub Actions sudah melakukan publish, kita tinggal ambil hasilnya
FROM base AS final
WORKDIR /app
COPY . .

# Optimasi RAM .NET untuk Docker
ENV DOTNET_GCHeapHardLimit=20000000
ENTRYPOINT ["dotnet", "kang_nangkring.dll"]