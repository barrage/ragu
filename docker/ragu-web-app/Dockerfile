FROM node:20-alpine

WORKDIR /app

# Copy what we need from the build context into the container
COPY app .
COPY public .
COPY server .
COPY package.json .
COPY tsconfig.json .
COPY nuxt.config.ts .
# submodule repo package-lock.json is not copied because it utilizes internal npm registry
COPY --from=config package-lock.json .
COPY --from=config .env .

RUN npm ci
RUN npm run build

EXPOSE 3000/tcp

CMD ["node", ".output/server/index.mjs"]