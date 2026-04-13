# STAGE 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /source

# Copy semua file
COPY . .

# Hapus solution agar tidak bentrok
RUN find . -name "*.sln" -delete

# Restore & Publish
RUN CSPROJ_PATH=\$(find . -name "*.csproj" | head -n 1) && \\
    dotnet publish "\$CSPROJ_PATH" -c Release -o /app/publish /p:UseAppHost=false

# STAGE 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS final
WORKDIR /app
COPY --from=build /app/publish .

# Optimasi RAM
ENV DOTNET_GCHeapHardLimit=20000000

# SCRIPT JALANKAN OTOMATIS:
# Mencari file .runtimeconfig.json untuk menentukan DLL mana yang merupakan aplikasi utama
ENTRYPOINT ["sh", "-c", "dotnet \$(ls *.runtimeconfig.json | sed 's/.runtimeconfig.json/.dll/')"]