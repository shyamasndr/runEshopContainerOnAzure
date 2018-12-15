
FROM registry.hub.docker.com/microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM    registry.hub.docker.com/microsoft/dotnet:2.1-sdk AS build
RUN     apt-get update && \
        apt-get install git-core 


FROM build AS source
WORKDIR /gitrepo
RUN     git clone https://github.com/shyamasndr/letskube.git 
WORKDIR /gitrepo/letskube
RUN dotnet restore 
RUN dotnet build --no-restore -c Release -o /app


FROM source AS publish
RUN dotnet publish --no-restore -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "LetsKube.dll"]