# FROM node:20-alpine

# RUN npm install

# RUN npm run build

# FROM nginx:alpine

# COPY out /usr/share/nginx/html

FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy files
COPY package*.json ./
COPY . .

# Install dependencies and build
RUN npm install
RUN npm run build
# RUN npm run export

# --- Stage 2: Serve with Nginx ---
FROM nginx:alpine

# Copy static export from builder stage
COPY --from=builder /app/out /usr/share/nginx/html
