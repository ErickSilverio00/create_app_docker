# Estágio 1: Obter código do GitHub
FROM alpine/git as clone
WORKDIR /app
RUN git clone https://github.com/materialAulas/image-of-the-day.git

# Estágio 2: Construir a aplicação Java com Maven
FROM maven:3.8.4-jdk-11 AS build
WORKDIR /app
COPY --from=clone /app/image-of-the-day/pom.xml .
RUN mvn dependency:go-offline
COPY --from=clone /app/image-of-the-day/src ./src
RUN mvn package -DskipTests

# Estágio 3: Construir a imagem Docker com a aplicação
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 80
CMD ["java", "-jar", "app.jar"]
