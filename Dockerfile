FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app

# Create a non-root user and group
RUN addgroup --system spring && adduser --system --ingroup spring spring

# Copy jar file
COPY --from=build /app/target/*.jar app.jar

# Change ownership of files to the new user
RUN chown -R spring:spring /app

# Switch to non-root user
USER spring

EXPOSE 8080:8080
ENTRYPOINT ["java","-jar","app.jar"]
