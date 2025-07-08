FROM node:20 AS build

WORKDIR /app

COPY package.json package-lock.json ./ 
COPY i18n/locales i18n/locales

RUN npm ci

COPY . .
COPY --from=config .env .env

RUN npx nuxt build

ENV PORT=3000
ENV HOST=0.0.0.0

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
