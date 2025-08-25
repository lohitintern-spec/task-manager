# === BUILDER STAGE ===
# Use a lightweight base image for building the application
FROM node:20-alpine AS builder

# Set the working directory for the builder stage
WORKDIR /app

# Copy the package.json and package-lock.json first to leverage layer caching
COPY package*.json ./
COPY prisma ./prisma/

# Install build-time dependencies (including devDependencies)
RUN npm install

# Copy the rest of the application code
COPY . .

# Run the Next.js build command
RUN npm run build

# === RUNNER STAGE ===
# Start a new, fresh image for the final production container
# This image will not contain any of the build tools or source code
FROM node:20-alpine AS runner

# Set the working directory for the runner stage
WORKDIR /app

# Copy only the necessary files from the builder stage
# This includes the build output (.next), node_modules, package.json, and Prisma client
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma

# Expose the port the Next.js app runs on
EXPOSE 3000

# Set the default command to start the application
CMD ["node", "server.js"]