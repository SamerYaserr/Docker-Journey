# -----------------------------
# Stage 1: Build the TypeScript app
# -----------------------------

# Use the official Node.js 18 image for building
FROM node AS builder

# Set the working directory inside the container to /app
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
# We copy these files first to leverage Docker's layer caching.
# Why? Because npm install is an expensive step. If only the source code changes (not dependencies),
# Docker will reuse the cache for this layer and won't re-run npm install unnecessarily.
COPY package*.json ./

# Install all dependencies (including devDependencies) for building
RUN npm install

# Copy all application source files into the container
# This comes AFTER npm install to avoid breaking the cache if source files change.
COPY . .

# Build the project (compile TypeScript files to JavaScript in the dist folder)
RUN npm run build


# -----------------------------
# Stage 2: Run the built app
# -----------------------------

# Use a new lightweight Node.js 18 image for running the app
FROM node AS runner

# Set the working directory inside the container to /app
WORKDIR /app

# Copy only the package files for installing production dependencies
# Again, copying these first allows caching npm install for production.
COPY package*.json ./

# Install only production dependencies (no devDependencies)
RUN npm install --only=production

# Copy the compiled JavaScript files from the builder stage
COPY --from=builder /app/dist ./dist

# Set an environment variable for the app (default port)
ENV PORT=3000

# Expose port 3000 so the container can listen for traffic on it
EXPOSE 3000

# Define the command to start the application
CMD ["node", "dist/server.js"]
