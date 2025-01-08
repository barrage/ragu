# this is executed in ragu-chat-api directory/context
FROM eclipse-temurin:17-jdk-jammy as build

WORKDIR /app

# install gradle
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://services.gradle.org/distributions/gradle-8.12-bin.zip \
    && unzip gradle-8.12-bin.zip -d /opt \
    && ln -s /opt/gradle-8.12/bin/gradle /usr/bin/gradle

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

RUN ./gradlew buildFatJar

# switch to a smaller base image to run the app
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=build /app/build/libs/llmao.jar .
COPY --from=build /app/application.conf .

CMD ["java", "-jar", "llmao.jar", "-config=application.conf"]