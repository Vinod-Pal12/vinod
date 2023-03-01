# build environment
FROM node:13.12.0-alpine@sha256:cc85e728fab3827ada20a181ba280cae1f8b625f256e2c86b9094d9bfe834766 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
# RUN npm ci --silent
# RUN npm install react-scripts@3.4.1 -g --silent
RUN npm install --legacy-peer-deps
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine@sha256:db81e6644d4896391d83b92e6cb7ff7f9f0cfa5a14d2c7a621d682be99d90f43
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]