# -------------------------
# base stage (shared files)
# -------------------------
# Use the official Node.js image as the base for later stages.
# Note: no tag is given so this uses the image's "latest" tag — pin a specific version for reproducibility (e.g. node:18).
FROM node AS base

# Set the working directory inside the image. All following RUN/COPY/etc. are relative to /app.
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
# We copy these files first to leverage Docker's layer caching.
# Why? Because npm install is an expensive step. If only the source code changes (not dependencies),
# Docker will reuse the cache for this layer and won't re-run npm install unnecessarily.
COPY package*.json ./

# -------------------------
# builder stage (production build)
# -------------------------
# Start from the "base" stage defined above. This stage will install dev deps and build the app.
FROM base AS builder

# Install dependencies (including devDependencies). This is typically needed for build tools (webpack, typescript, etc).
# Because package*.json were copied in base, Docker can cache this layer until manifests change.
RUN npm install

# Copy the rest of the application source into the image.
# This includes source files, build config, etc.
# This comes AFTER npm install to avoid breaking the cache if source files change.
COPY . .

# Run the build script defined in package.json (commonly produces ./dist or ./build).
# The result will be available for later stages via --from=builder.
RUN npm run build

# -------------------------
# production stage
# -------------------------
# Use a specific Node image (node:18) for production to avoid relying on "latest".
# This stage produces a smaller runtime image containing only what is needed to run the built app.
FROM node:18 AS production

# Set working directory for the production image.
WORKDIR /app

# Copy package manifests into the production stage so we can install only runtime deps.
COPY package*.json ./

# Install only production dependencies (skip devDependencies).
# `--only=production` ensures dev tooling is not installed (reduces image size).
RUN npm install --only=production

# Copy built artifacts from the builder stage into this production image.
# Expects the builder produced a /app/dist directory; it places it at ./dist here.
COPY --from=builder /app/dist ./dist

# Document the port the production container will listen on (informational).
EXPOSE 4000

# Default command to start the production application (runs the "start" script from package.json).
CMD ["npm", "run", "start"]

# -------------------------
# development stage
# -------------------------
# Start from the "base" stage so we get the copied package*.json, then set up a fast dev image.
FROM base AS development

# Install dependencies (including devDependencies) so `npm run dev` can run with watchers, hot reloaders, etc.
RUN npm install

# Copy full source for live development.
COPY . .

# Document the port the container will listen on at runtime (purely informational for users/tools).
EXPOSE 4000

# Default command for the development image: run the dev script from package.json.
# This should start whatever dev server or watcher you use (e.g. nodemon, ts-node-dev, next dev).
CMD ["npm", "run", "dev"]
