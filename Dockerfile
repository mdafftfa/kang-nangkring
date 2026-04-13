# Stage 1: Runtime .NET 10
FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS base
WORKDIR /app

# Stage 2: Ambil file dari folder publish
# GitHub Actions menaruh file di folder 'publish', 
# tapi saat 'git pull' di VPS, kita berada di root project.
FROM base AS final
WORKDIR /app
COPY ./publish/ .

# Optimasi RAM (20MB Limit sesuai rencana awal)
ENV DOTNET_GCHeapHardLimit=20000000
ENTRYPOINT ["dotnet", "kang_nangkring.dll"]