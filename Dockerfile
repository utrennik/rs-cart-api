FROM node:16-alpine3.15 AS base
WORKDIR /app
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run build

FROM node:16-alpine3.15 AS application
COPY --from=base /app/package*.json ./
RUN npm i --only=production
RUN npm i pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["pm2-runtime", "dist/main.js"]
