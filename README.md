# Lab 5 - Multi-stage build

## Setup Instructions

### 1. Building the image

Passing the `VERSION` build argument is required. This process may take a few minutes.

```
docker build --build-arg VERSION=v5.0.0 -t lab5_react .
```

### 2. Running the container

```
docker run -d -p 8801:80 --name app_lab5 lab5_react
```

### 3. Verifying the deployment

Check the container's status. The (healthy) indicator should appear after approximately 10 seconds.

```
docker ps --filter name=app_lab5
```

### 4. Accessing the application

Open your browser and navigate to: http://localhost:8801
