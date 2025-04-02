FROM openjdk:17-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl
COPY . /app
RUN apt-get update && apt-get install -y net-tools procps iputils-ping
RUN javac HelloWorld.java
#CMD ["java", "HelloWorld"]
CMD ["java", "-Djava.net.preferIPv4Stack=true", "HelloWorld"]

