# frontend-basic/

# Use Node.js base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy application files
COPY . .

# Expose the port your Express app runs on (default is 3000)
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]