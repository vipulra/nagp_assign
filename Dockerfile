From openjdk:11
ARG JAR_File
COPY ${JAR_File} /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]