# === STAGE 1: Build the Angular App ===
FROM node:24-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration=production

# === STAGE 2: Serve the App with Nginx ===
FROM nginx:alpine

# FIX: Added "./" to explicitly reference the local build context folder
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled frontend static assets
COPY --from=build /app/dist/*/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
