# this is executed in ragu-chat-api directory/context
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app

ARG GRADLE_VERSION=8.12

# install gradle
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
    && unzip gradle-$GRADLE_VERSION-bin.zip -d /opt \
    && ln -s /opt/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle

# copy everything from build context we need to build the jar
COPY settings.gradle.kts .
COPY build.gradle.kts .
COPY src/main src/main
COPY gradlew gradlew
COPY gradle gradle
COPY gradlew.bat .
# these two come from additional build context check the docker-compose file
COPY --from=config application.conf .
COPY --from=config gradle.properties .

RUN gradle wrapper --gradle-version $GRADLE_VERSION \
    && ./gradlew buildFatJar

# switch to a smaller base image to run the app
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=build /app/build/libs/llmao.jar .
COPY --from=build /app/application.conf .

CMD ["java", "-jar", "llmao.jar", "-config=application.conf"]