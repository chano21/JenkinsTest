FROM maven:3.5.2-jdk-8 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:9
COPY --from=build /usr/src/app/target/hello.jar /usr/app/hello.jar 
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/app/hello.jar"]