FROM mcr.microsoft.com/dotnet/runtime:10.0
WORKDIR /app
# Menyalin file yang sudah di-build dari GitHub Action
COPY . .
ENTRYPOINT ["dotnet", "kang-nangkring.dll"]