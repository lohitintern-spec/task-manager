# Stage 1: The Build Environment
# This stage builds your Next.js application
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Next.js application for production
RUN npm run build

# Stage 2: The Production Environment
# This stage creates the final, optimized image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install only production dependencies
COPY package*.json ./
RUN npm install --production

# Copy the built application from the 'builder' stage
COPY --from=builder /app/.next ./.next

# Copy the public assets directory
COPY --from=builder /app/public ./public

# Expose the port Next.js runs on (default is 3000)
EXPOSE 3000

# The command to start the Next.js production server
CMD ["npm", "start"]