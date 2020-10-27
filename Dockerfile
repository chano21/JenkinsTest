# our base build image
FROM maven:3.5.2-jdk-8 as maven

WORKDIR /usr

# copy the Project Object Model file
COPY ./pom.xml ./pom.xml

# fetch all dependencies
RUN mvn dependency:go-offline -B

# copy your other files
COPY ./src ./src

# build for release
# NOTE: my-project-* should be replaced with the proper prefix
RUN mvn package && cp /usr/target/*.jar hello.jar


# smaller, final base image
FROM openjdk:8
# OPTIONAL: copy dependencies so the thin jar won't need to re-download them
# COPY --from=maven /root/.m2 /root/.m2

# set deployment directory
WORKDIR /usr

# copy over the built artifact from the maven image
COPY --from=maven /usr/hello.jar ./hello.jar

# set the startup command to run your binary
CMD ["java", "-jar", "/usr/hello.jar"]