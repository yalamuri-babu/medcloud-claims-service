FROM amazoncorretto:21-alpine

WORKDIR /app

RUN apk upgrade --no-cache

RUN addgroup -S medcloud && \
    adduser -S medcloud -G medcloud

COPY --chown=medcloud:medcloud \
    target/claims-service-0.0.1-SNAPSHOT.jar \
    app.jar

USER medcloud

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
