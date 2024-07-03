# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Package
FROM openjdk:17-jdk-slim

# Создание непривилегированного пользователя
RUN useradd -m springuser

# Устанавливаем рабочую директорию и копируем приложение
WORKDIR /app
COPY --from=build /app/target/config-client-0.0.1-SNAPSHOT.jar app.jar

# Изменяем права доступа к файлам и директориям
RUN chown -R springuser:springuser /app

# Меняем пользователя
USER springuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]