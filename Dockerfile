FROM node:lts as builder

WORKDIR /app

COPY . .

RUN yarn install \
  --prefer-offline \
  --frozen-lockfile \
  --non-interactive \
  --production=false

RUN yarn build

RUN rm -rf node_modules && \
  NODE_ENV=production yarn install \
  --prefer-offline \
  --pure-lockfile \
  --non-interactive \
  --production=true

FROM node:lts

WORKDIR /app

COPY --from=builder /app/.nuxt .nuxt
COPY --from=builder /app/static static
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/package.json package.json

ENV HOST 0.0.0.0
EXPOSE 3000

CMD [ "yarn", "start" ]
