# STAGE 1: Build menggunakan SDK .NET 10
FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /src

# Copy file project dan restore dependensi
COPY ["src/kang_nangkring.csproj", "src/"]
RUN dotnet restore "src/kang_nangkring.csproj"

# Copy seluruh source code dan build
COPY . .
WORKDIR "/src/src"
RUN dotnet publish "kang_nangkring.csproj" -c Release -o /app/publish

# STAGE 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS final
WORKDIR /app
COPY --from=build /app/publish .

# Optimasi RAM untuk VPS e2-micro
ENV DOTNET_GCHeapHardLimit=20000000
ENTRYPOINT ["dotnet", "kang_nangkring.dll"]