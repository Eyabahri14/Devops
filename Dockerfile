# Set base image to OpenJDK 11
FROM openjdk:11

# Expose container port 8089
EXPOSE 8089

#Copy compiled jar from the build context to the container/The JAR file is renamed as "achat.jar" in the container
ADD target/achat-1.0.jar achat.jar

#Define entry point
ENTRYPOINT ["java", "-jar", "achat.jar"]
