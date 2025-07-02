# ===========================
# Ocelot API Gateway Dockerfile
# ===========================

# 1. Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy csproj and restore
COPY *.sln .
COPY OcelotGateway/*.csproj ./OcelotGateway/
RUN dotnet restore

# Copy all source files and build
COPY OcelotGateway/. ./OcelotGateway/
WORKDIR /app/OcelotGateway
RUN dotnet publish -c Release -o out

# 2. Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/OcelotGateway/out ./

# Expose the gateway port (e.g. 5000)
EXPOSE 5000

# Start the gateway
ENTRYPOINT ["dotnet", "OcelotGateway.dll"]
