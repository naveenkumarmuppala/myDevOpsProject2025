# Build stage
FROM maven:3.9.14-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:10.1.54-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/my-webapp.war /usr/local/tomcat/webapps/my-webapp.war

EXPOSE 8085
CMD ["catalina.sh", "run"]