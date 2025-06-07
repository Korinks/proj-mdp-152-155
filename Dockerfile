# === Stage 1: Build the application using Maven ===
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and resolve dependencies early
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# === Stage 2: Deploy to Tomcat ===
FROM tomcat:9.0-jdk17-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=builder /app/target/WebAppCal-1.3.5.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat default port
EXPOSE 8080

CMD ["catalina.sh", "run"]

