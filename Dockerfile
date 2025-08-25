# === BUILDER STAGE ===
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma/
RUN npm install
COPY . .
RUN npm run build

# === RUNNER STAGE ===
# Use a minimal base image for the final production container
FROM node:20-alpine AS runner

# Set the working directory
WORKDIR /app

# Copy the self-contained standalone output from the builder stage
COPY --from=builder /app/.next/standalone ./

# The standalone output includes all necessary files,
# so you don't need to copy them separately.
# The following lines are no longer needed:
# COPY --from=builder /app/.next/static ./.next/static
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/public ./public
# COPY --from=builder /app/prisma ./prisma


# Expose the port the Next.js app runs on
EXPOSE 3000

# Set the default command to start the application
CMD ["node", "server.js"]