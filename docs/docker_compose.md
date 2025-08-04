


- Docker command to handle containers
	Network: set up port for connecting 2 containers
	Container 1: Service a - MongoDB
	Container 2: Service b - Mongo Express (UI for MongoDB)

docker_compose.yml
___________________________________________________________
version: "3.9"

services:
    container_name_1:
        build:
        volumes:
    container_name_2:
        image:
        volums:
        ports:
        depends_on:

network:

volumes:

___________________________________________________________


Next topics:
- MongoDB
- Warp - IDE
