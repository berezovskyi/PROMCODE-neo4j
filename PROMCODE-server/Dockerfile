FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create uploaded directory
RUN mkdir -p uploaded

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
