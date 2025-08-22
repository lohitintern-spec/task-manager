# Use a lightweight base image for Node.js
# The "alpine" version is much smaller and more secure
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json first
# This allows Docker to cache the npm install step
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Run the Next.js build command to create the production app
RUN npm run build

# Expose the port the Next.js app runs on
EXPOSE 3000

# Set the default command to start the application
CMD ["npm", "start"]