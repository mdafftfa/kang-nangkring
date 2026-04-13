FROM mcr.microsoft.com/dotnet/runtime:10.0-preview AS base
WORKDIR /app

FROM base AS final
WORKDIR /appcontainer
COPY . .

ENV DOTNET_GCHeapHardLimit=20000000
ENTRYPOINT ["dotnet", "kang_nangkring.dll"]