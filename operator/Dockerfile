# Use the official Node.js image from the Docker Hub
FROM node:14

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy application dependency manifest to the container image
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy local code to the container image
COPY .env .
COPY pinner-ipfsd .

# The port that your app will run on
EXPOSE 3000

# Run the application
CMD ["node", "pinner-ipfsd.js"]