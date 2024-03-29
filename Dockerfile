FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 5000

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["jenkinciTest/jenkinciTest.csproj", "jenkinciTest/"]
RUN dotnet restore "jenkinciTest/jenkinciTest.csproj"
COPY . .
WORKDIR "/src/jenkinciTest"
RUN dotnet build "jenkinciTest.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "jenkinciTest.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "jenkinciTest.dll"]