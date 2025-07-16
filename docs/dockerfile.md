# Dockerfile

## Definition
    Dockerfile is a plain text file containg a set of instructions to define how docker image should be built. These instructions are excuted step-by-step to assemble the image.
    A Dockerfile is used with:
        - the 'docker build' command to create an image manually
        - Or as part of 'docker-compose' workflows via the 'build' field in 'docker-compose.yml'

## Usage
    Inside the folde of Dockerfile
    ```bash
        docker build -t image_name .
    ```

## Template
________________________________________________
#Base image
FROM

#install system dependencies
RUN

#set working directory inside container
WORKDIR

#copy local files into the container
COPY . .

#run the application
CMD ["",""]
________________________________________________

## All Instructions in Dockerfile

| Instruction   | Description                                              |
|---------------|----------------------------------------------------------|
| `ADD`         | Add local or remote files and directories.               |
| `ARG`         | Use build-time variables.                                |
| `CMD`         | Specify default commands.                                |
| `COPY`        | Copy files and directories.                              |
| `ENTRYPOINT`  | Specify default executable.                              |
| `ENV`         | Set environment variables.                               |
| `EXPOSE`      | Describe which ports your application is listening on.  |
| `FROM`        | Create a new build stage from a base image.             |
| `HEALTHCHECK` | Check a container's health on startup.                   |
| `LABEL`       | Add metadata to an image.                                |
| `MAINTAINER`  | Specify the author of an image.                          |
| `ONBUILD`     | Specify instructions for when the image is used in a build. |
| `RUN`         | Execute build commands.                                  |
| `SHELL`       | Set the default shell of an image.                       |
| `STOPSIGNAL`  | Specify the system call signal for exiting a container. |
| `USER`        | Set user and group ID.                                   |
| `VOLUME`      | Create volume mounts.                                    |
| `WORKDIR`     | Change working directory.                                |
        