FROM ubuntu:latest

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV MAVEN_HOME /usr/share/maven
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY files/spring-petclinic-2.7.3.jar /usr/src/spring-petclinic-2.7.3.jar

EXPOSE 8080

WORKDIR /app

