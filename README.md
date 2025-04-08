# rails-microservices-app

Example of Microservices for a Test App
Let's say you want to build a simple online store as a test app using microservices. Each microservice will handle a specific domain or functionality in your app. Below are some example services you can create:

### 1. User Service

Responsibility: Manages user authentication and user profiles.

### 2. Product Service

Responsibility: Manages products in the marketplace (creating, listing, and updating products).

Example Project Structure (Basic)

```
microservices/
├── user-service/ # Rails service for user management (authentication, profiles)
│ ├── app/
│ ├── config/
│ └── db/
├── product-service/ # Rails service for managing products
│ ├── app/
│ ├── config/
│ └── db/
├── frontend-app/ # next app
│ ├── app/
│ ├── config/
├── docker-compose.yml # For orchestrating the services using Docker
├── nginx.conf
└── config/
```

### Deploy

```
$ docker-compose up --build
```
