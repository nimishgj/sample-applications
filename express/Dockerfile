# Use Node.js with full Debian (not Alpine to avoid compatibility issues)
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Compile TypeScript
RUN npm run build

# Expose the port your app runs on
EXPOSE 3005

# Run the compiled JS
CMD ["node", "dist/index.js"]