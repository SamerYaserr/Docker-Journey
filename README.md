# Docker-Journey

Welcome to **Docker-Journey**! This repository serves as a hands-on guide to learning Docker fundamentals through a simple Node.js application. It demonstrates how to containerize a Node.js app, manage images and containers, and use Docker Compose for multi-container setups. Whether you're new to Docker or looking to refresh your skills, this repo provides practical examples and commands to get you started.

## Description

This project includes a basic Node.js server (likely using Express or similar) that runs on port 3000. The repository contains a `Dockerfile` for building the image, along with Docker Compose files for development and production environments. Key concepts covered include:

- Building and running Docker images
- Managing containers (start, stop, remove)
- Volume binding for hot reloading in development
- Using anonymous volumes to protect dependencies like `node_modules`
- Orchestrating services with Docker Compose

The app is structured with source code in a `src` directory, making it easy to bind volumes for live code changes.

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/SamerYaserr/Docker-Journey.git
   cd Docker-Journey
   ```

2. **For development mode with hot reloading, use**:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
   ```

3. **To stop and remove the resources**:
   ```bash
    docker compose -f docker-compose.yml -f docker-compose.dev.yml down
   ```
   Visit `http://localhost:3000` in your browser.

## Docker Commands

Below are the essential Docker commands to build, run, and manage your application.

### 1. Build the Docker Image

Builds the Docker image from Dockerfile.

```bash
docker build -t (name:version) .
```

### 2. View Docker images

This command lists all Docker images stored on your local machine.

```bash
docker images
```

### 3. Run Docker Container

Runs a container from a built image, mapping port 3000 on your host to port 3000 in the container.

```bash
docker run -p 3000:3000 --name (container_name) (image_name)
```

- `-p 3000:3000` Maps port 3000 on your host to port 3000 in the container.

### 4. Run in Detached Mode

Run the container in the background (detached mode).

```bash
docker run -d -p 3000:3000 --name (container_name) (image_name)
```

### 5. View Running Containers

List all running containers to check the status of your app.

```bash
docker ps
```

To include stopped containers, use:

```bash
docker ps -a
```

### 6. Stop a Running Container

Stop the container when you’re done.

```bash
docker stop (container_name)
```

### 7. Start a Stopped Container

Restart a previously stopped container.

```bash
docker start (container_name)
```

### 8. Remove a Container

Delete the container when no longer needed.

```bash
docker rm (container_name)
```

### 9. Force Remove a Container

Stop the container if it is running then remove it.

```bash
docker rm (container_name) -f
```

### 10. Access the Container’s Shell

Open a shell inside the running container for debugging or manual commands.

```bash
docker exec -it (container_name) bash
```

### 11. View Container Logs

Check the logs of a running or stopped container for debugging.

```bash
docker logs (container_name)
```

### 12. Run Container with Hot Reloading - 2 Way Binding

This will sync your project directory with directory inside docker container. Changes on either side will impact the other (security vulnerability).

```bash
docker run --name (container_name) -d -p 3000:3000 (directory_path:docker_directory) -v (image_name)
```

### 13. Run Container with How Reloading - 1 Way Binding

This will sync your project directory with directory inside docker container using `ro` (read only). It's a 1 way binding because changes happening to the project directory will affect the docker container directory but NOT visa versa.

```bash
docker run --name (container_name) -d -p 3000:3000 -v (directory_path:docker_directory:ro) (image_name)
```

`$(pwd)` represents the current working directory in Linux.
`${PWD}` represents the current working directory in windows.

This is the best way FOR NOW.

If your application code is inside a src folder. It would be a good idea to only 1 way bind the src folder in your current working directory with the src folder inside the container.

Example:

```bash
docker run --name test-container -d -p 3000:3000 -v $(pwd)/src:/app/src test-image
```

Hot Reloading - Binding only syncs things with each other. But it won't change the image or the container content!

The concept of Hot Reloading in Docker is primarily beneficial in development environments.

### 14. Run Container with Hot Reloading - 1 Way Binding - Anonymous Volumes

Use this if U want to run a container and U don't want a specific folder in a directory in the container to be changed.

Example:

```bash
docker run --name node-app-container -v ${PWD}:/app -v /app/node_modules -d -p 3000:3000 node-app
```

This means if something happens to the node_modules folder in your working directory, the node_modules folder in the docker container will not be affected.

### 15. Start Services in docker-compose yml file in Detached Mode

This command will start and run the services `docker-compose.yml`. U now don't need to manually build images from Dockerfile. U don't need to manually run containers.

```bash
docker compose up -d
```

If the `build` directive is used inside the docker compose file it will build an image locally and runs a container from it.

If U have multiple docker compose files U need to specify which file U want to use.

Example:

```bash
docker compose -f docker-compose.dev.yml up -d
```

If U have multiple docker compose files with a base compose file containing the base common things for all other compose files U need to add the base compose file in the command.

Example:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

If for some reason U wanted to build a new image and then run a container use the `--build` flag.

### 16. Stop and Remove Resources Created by docker-compose yml file

It won't remove the images created before but will stop and remove the containers.

```bash
docker compose down
```
