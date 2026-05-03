# My WebApp

`my-webapp` is a simple Java web application packaged as a WAR file. It is designed as part of an end-to-end DevOps automation project, with Maven build support, Docker containerization, Jenkins CI/CD, SonarCloud analysis, Nexus artifact publishing, Docker Hub image publishing, Tomcat deployment, Jira updates, and email notifications.

## Tech Stack

- Java web application packaged as a WAR
- Maven
- JSP
- Servlet API
- Apache Tomcat
- Docker
- Jenkins
- SonarCloud
- Nexus Repository
- Jira integration

## Project Structure

```text
my-webapp/
+-- Dockerfile
+-- Jenkinsfile
+-- pom.xml
`-- src/
    `-- main/
        `-- webapp/
            +-- index.jsp
            `-- WEB-INF/
                `-- web.xml
```

## Prerequisites

For local development:

- Java 17 or later
- Maven 3.9 or later
- Docker, if building or running the container image

For the Jenkins pipeline:

- Jenkins with Maven and JDK tools configured
- Docker available on the Jenkins agent
- Nexus Repository access
- SonarCloud project and token
- Docker Hub credentials
- Tomcat manager credentials
- Jira integration configured in Jenkins
- Email Extension plugin configured

## Build Locally

From the `my-webapp` directory, run:

```bash
mvn clean package
```

The generated WAR file will be created at:

```text
target/my-webapp.war
```

## Run on Tomcat

Copy the generated WAR file to a Tomcat `webapps` directory:

```bash
cp target/my-webapp.war <tomcat-home>/webapps/
```

Then start Tomcat and open:

```text
http://localhost:8080/my-webapp/
```

The default page displays a simple confirmation message from `index.jsp`.

## Build and Run with Docker

Build the Docker image:

```bash
docker build -t my-webapp .
```

Run the container:

```bash
docker run -d --name my-webapp -p 8085:8080 my-webapp
```

Open the application:

```text
http://localhost:8085/my-webapp/
```

## Docker Image

The Dockerfile uses a multi-stage build:

1. Builds the WAR with Maven and Eclipse Temurin JDK 17.
2. Copies the WAR into a Tomcat 10 runtime image.
3. Runs the application with `catalina.sh run`.

The Jenkins pipeline publishes images to Docker Hub using:

```text
mnaveenk85/my-webapp
```

with both the Jenkins build number tag and the `latest` tag.

## Jenkins CI/CD Pipeline

The included `Jenkinsfile` automates the following stages:

1. Cleans the Jenkins workspace.
2. Checks out the `main` branch from GitHub.
3. Extracts a Jira issue key from the latest commit message.
4. Builds the Maven WAR package.
5. Uploads the WAR artifact to Nexus Repository.
6. Runs SonarCloud analysis.
7. Stops and removes any existing local Docker container and image.
8. Builds and pushes Docker images to Docker Hub.
9. Downloads the WAR artifact back from Nexus.
10. Deploys the WAR to Tomcat using the Tomcat Manager API.
11. Sends Jira build and deployment information.
12. Updates Jira issue labels and transitions the issue after a successful pipeline.
13. Sends an HTML email notification with the pipeline result.

## Jenkins Parameters

The pipeline accepts the following parameter:

| Parameter | Description |
| --- | --- |
| `JIRA_KEY` | Jira issue key, such as `DSO-2`. The pipeline can also extract this from the latest commit message. |

## Jenkins Credentials

The pipeline expects these Jenkins credentials to exist:

| Credential ID | Purpose |
| --- | --- |
| `nexus-creds` | Username and password for Nexus Repository |
| `sonar-token` | SonarCloud authentication token |
| `docker-creds` | Docker Hub username and password |
| `tomcat-creds` | Tomcat Manager username and password |

## Pipeline Environment Values

The `Jenkinsfile` currently uses these key environment values:

| Variable | Value |
| --- | --- |
| `APP_NAME` | `my-webapp` |
| `TOMCAT_URL` | `http://192.168.161.4:8080` |
| `SONAR_HOST_URL` | `https://sonarcloud.io` |
| `SONAR_ORG` | `dso-nkm` |
| `SONAR_PROJECT` | `my-webapp` |
| `REPOSITORY_URL` | `http://192.168.161.7:8081/repository` |
| `REPOSITORY_REPO` | `maven-releases` |
| `DOCKER_IMAGE` | `mnaveenk85/my-webapp` |

Update these values before running the pipeline in a different environment.

## Artifact Details

Maven project coordinates:

```text
groupId: com.example
artifactId: my-webapp
version: 1.0-SNAPSHOT
packaging: war
```

The Maven build final name is:

```text
my-webapp.war
```

## Notes

- The application home page is located at `src/main/webapp/index.jsp`.
- `web.xml` defines a `HelloServlet` mapping for `/hello`; add the corresponding servlet class under `src/main/java/com/example/HelloServlet.java` if that endpoint is required.
- The Dockerfile exposes port `8085`, but Tomcat runs inside the container on port `8080`; map host port `8085` to container port `8080` when running locally.
