# this is executed in ragu-chat-api directory/context

ARG GRADLE_VERSION=8.14.2

FROM gradle:$GRADLE_VERSION-jdk21-ubi-minimal AS build

WORKDIR /app

# copy everything from build context we need to build the jar
COPY ragu-plugin ragu-plugin
COPY core core
COPY app app
COPY plugins plugins
COPY adapters adapters
COPY gradle gradle
COPY gradlew gradlew
COPY gradlew.bat gradlew.bat
COPY build.gradle.kts build.gradle.kts
COPY settings.gradle.kts settings.gradle.kts

# these two come from additional build context check the docker-compose file
COPY --from=config application.conf .
COPY --from=config gradle.properties .

# RUN gradle wrapper 
RUN gradle app:buildFatJar --no-daemon

# switch to a smaller base image to run the app
FROM eclipse-temurin:21.0.7_6-jre-ubi9-minimal

WORKDIR /app

COPY --from=build /app/app/build/libs/llmao.jar .
COPY --from=build /app/application.conf .

CMD ["java", "-jar", "llmao.jar", "-config=application.conf"]
