# -------------Stage 1: Build ------
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /build

# dependency cache
COPY pom.xml .
RUN mvn -B -q -e -DskipTests dependency:go-offline

#source copy
COPY src ./src

# build jar
RUN mvn -B -q -DskipTests package


# ------------Stage 2: Runtime -------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# copy only jar (no maven here )
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
# run app
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "app.jar"]