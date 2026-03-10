# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw -q -DskipTests dependency:go-offline

COPY src src
RUN ./mvnw -q -DskipTests clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=build /app/target/*-SNAPSHOT.jar /app/app.jar

ENV SERVER_PORT=8888 \
    GITHUB_USER= \
    GITHUB_PASS=

EXPOSE 8888
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
