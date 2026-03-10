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

ENV SERVER_PORT=8080 \
    SPRING_CONFIG_IMPORT=optional:configserver:http://hr-config-server:8888 \
    EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://hr-eureka-server:8761/eureka

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
