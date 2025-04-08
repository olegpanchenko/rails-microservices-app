# Product Service

## Overview

This is the authentication service for a microservices-based system. It provides functionalities to:

The service is built with **Ruby on Rails** and includes features for **acceptance testing** and **Swagger UI documentation** generation.

## Prerequisites

Ensure you have the following installed:

- Ruby (version `3.2.2` or compatible)
- Rails (version `8.0.2` or compatible)

## Setup

### Install dependencies:

`bundle install`

### Set up the database:

```
rails db:create
rails db:migrate
```

### Start the Rails server:

```
rails server
```

### Running Tests

To run the acceptance tests, you can use the following command:

```
bundle exec rspec
```

This will run the test suite and provide feedback on whether the API is working as expected.

### Generating Swagger UI Documentation

To generate the Swagger UI documentation:

Install Swagger UI (if not already installed).

Generate API Documentation using the following Rake task:

```
rake docs:generate
```

This will generate an open_api.json file under the public/docs directory.

View the documentation in Swagger UI by visiting the URL:

```
http://localhost:3000/api-docs/index.html
```
