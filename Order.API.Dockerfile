
FROM registry.hub.docker.com/microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM    registry.hub.docker.com/microsoft/dotnet:2.1-sdk AS build
RUN     apt-get update && \
        apt-get install git-core 
RUN dotnet --version
WORKDIR /gitrepo
RUN     git clone https://github.com/shyamasndr/eShopOnContainers.git 
WORKDIR /gitrepo/eShopOnContainers/src/Services/Ordering/Ordering.API
RUN dotnet --version
RUN dotnet restore 
RUN dotnet build --no-restore -c Release -o /app


FROM build AS publish
RUN dotnet publish --no-restore -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Ordering.API.dll"]