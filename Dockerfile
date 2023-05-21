FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim-amd64 AS build
WORKDIR /src
COPY ["misono.io.csproj", "."]
RUN dotnet restore "./misono.io.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "misono.io.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "misono.io.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "misono.io.dll"]