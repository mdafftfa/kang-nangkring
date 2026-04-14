FROM mcr.microsoft.com/dotnet/runtime:10.0
WORKDIR /app
COPY . .

ENTRYPOINT ["dotnet", "kang-nangkring.dll"]