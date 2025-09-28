# syntax=docker.io/docker/dockerfile:1

FROM node:24-alpine AS base

FROM base AS deps
WORKDIR /app
COPY package*.json ./
ENV NODE_ENV=production \
    HUSKY=0
RUN npm ci --omit=dev --ignore-scripts

FROM base AS builder
WORKDIR /app
COPY . .
RUN npm ci

FROM dercilio/andromeda:0.1.0-draft43 AS runner
LABEL maintainer="dafdev"

WORKDIR /usr/src/myapp

# Copy only necessary files from build stage
COPY --from=builder /app/.env ./
COPY --from=builder /app/package.json ./
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/src ./dist

ENV PORT=8080
# ENV RUST_LOG=debug

EXPOSE 8080

# HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1

CMD ["andromeda", "run", "dist/app.js" ]