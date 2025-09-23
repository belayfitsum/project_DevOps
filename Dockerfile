FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install 

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Run the app
CMD ["node", "app.js"]
