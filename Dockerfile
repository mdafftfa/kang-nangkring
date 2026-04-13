# STAGE 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /source

# Copy semua file dulu agar bisa mendeteksi lokasi csproj
COPY . .

# Restore & Publish otomatis mencari file .csproj yang ada
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# STAGE 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS final
WORKDIR /app
COPY --from=build /app/publish .

# Optimasi RAM
ENV DOTNET_GCHeapHardLimit=20000000
# Menggunakan shell agar bisa mencari file .dll secara dinamis jika nama berbeda
ENTRYPOINT ["sh", "-c", "dotnet $(ls *.dll | head -n 1)"]