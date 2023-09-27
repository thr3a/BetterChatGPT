FROM node:20-bookworm-slim as base
FROM base AS builder

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build

FROM base as production

RUN yarn config set prefix ~/.yarn && \
  yarn global add serve

WORKDIR /app
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["/root/.yarn/bin/serve", "-s", "dist", "-l", "3000"]
