#######################
# Production builder stage
#######################

FROM node:lts-alpine AS build

ENV VITE_API_URL=http://localhost:3000

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build

#######################
# Production stage
#######################

FROM nginx:stable-alpine AS production

COPY --from=build /app/dist /usr/share/nginx/html

COPY /nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]