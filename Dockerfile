FROM amazoncorretto:21-alpine

WORKDIR /app

RUN apk upgrade --no-cache

RUN addgroup -S -g 10001 medcloud && \
    adduser -S -D -H -u 10001 -G medcloud medcloud

USER 10001:10001

COPY --chown=medcloud:medcloud \
    target/medcloud-claims-service-0.0.1-SNAPSHOT.jar \
    app.jar

USER medcloud

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
