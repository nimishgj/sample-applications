FROM maven:3.9.8-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean compile package -Dmaven.test.skip=true

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/java-api-server-1.0.0.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]