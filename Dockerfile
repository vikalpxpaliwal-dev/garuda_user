# Build stage
FROM ubuntu:22.04 AS builder

# Install prerequisites
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter from stable branch
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support (already enabled by default on stable, but good to ensure)
RUN flutter config --enable-web

WORKDIR /app

# Copy files and resolve dependencies
COPY . .
RUN flutter pub get

# Build the Flutter web application
RUN flutter build web --release

# Production stage
FROM nginx:alpine
# Copy built assets from builder
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
