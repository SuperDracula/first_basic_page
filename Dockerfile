# === STAGE 1: Build ứng dụng với Maven ===
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build file WAR và bỏ qua test để tăng tốc
RUN mvn clean package -DskipTests

# === STAGE 2: Chạy ứng dụng với Tomcat 9 ===
FROM tomcat:9.0-jdk21-openjdk-slim
# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ STAGE 1 và đổi tên thành ROOT.war
# (Để ứng dụng chạy ngay ở đường dẫn gốc: https://ten-app.onrender.com/)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]