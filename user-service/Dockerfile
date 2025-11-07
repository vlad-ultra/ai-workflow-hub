FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY src ./src
EXPOSE 4001
CMD ["npm", "start"]
