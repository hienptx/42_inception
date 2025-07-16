[Link to Docker cheet sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)

[Docker best practices](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/)

## Install Docker Engine for Ubuntu 24.04
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker run hello-world
```

## Docker Build overview
Docker Build implements a client-server architecture, where:

Client: Buildx is the client and the user interface for running and managing builds.

Server: BuildKit is the server, or builder, that handles the build execution.

	```bash
		docker build
		docker build --file 
	```
The build request includes:

- The Dockerfile
- Build arguments
- Export options
- Caching optio

Examples of resources that BuildKit can request from Buildx include:

- Local filesystem build contexts
- Build secrets
- SSH sockets
- Registry authentication tokens

## Dockerfile overview

It all starts with a Dockerfile. Docker builds images by reading the instructions from a Dockerfile.
A Dockerfile is a text file containing instructions for building your source code. 
		
	|Instruction | Description |
	|----------|----------|
	| FROM [image] | Base image/ userland OS: Defines a base for your image, a starting point, the root filesystem and environment that everything else is built on|
	| RUN [command] | Executes any commands in a new layer on top of the current image and commits the result. RUN also has a shell form for running commands.|
	| WORKDIR [directory] | Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it in the Dockerfile. |
	| COPY [src] [dest] | Copies new files or directories from [src] and adds them to the filesystem of the container at the path [dest]. |
	| CMD [command] | Lets you define the default program that is run once you start the container based on this image. Each Dockerfile only has one CMD, and only the last CMD instan ce is respected when multiple exist.|

To build an image, run this command under the same folder of Dockerfile:
	```bash
		docker build -t my-nginx-image .
	```
To list all built images
	```bash
		docker images
	```

To delete an image,-f for force
	```bash
		docker rmi <image_name> -f
	```

Only builds a Docker image from a Dockerfile.
Does not start any containers.

## Docker-compose
### Docker Network

To create network for containers
	```bash
		docker network create
		docker network ls	  	
	``
under the same folder of docker-compose.yml 
	```bash
		docker compose up
	```
Builds images (if needed) and starts containers as defined in docker-compose.yml.
Manages multiple services, networks, and volumes.

## Monitor

Check if docker is running
	```bash
		systemctl is-active docker
	```

Check disk usage
	```bash
		docker system df
	```
Check running containers
	```bash
		docker ps
	```

## Push an image to Docker Hub
	```bash
		docker login -u user_name foo --password-stdin
		echo "YOUR_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
	```

To tag the image with registry
	docker tag <base_image_name>:<base_image_tag> your_dockerhub_username/<base_image_name>:<base_image_tag>

Now push the image
	docker push your_dockerhub_username/base_image_name:base_image_tag
