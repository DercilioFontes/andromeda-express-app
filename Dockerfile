# syntax=docker.io/docker/dockerfile:1

FROM node:24-alpine AS base

FROM base AS deps
WORKDIR /app
COPY package*.json ./
ENV NODE_ENV=production
RUN npm ci --omit=dev

FROM base AS builder
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM dercilio/andromeda AS runner
LABEL maintainer="dafdev"

WORKDIR /usr/src/myapp

# Copy only necessary files from build stage
COPY --from=builder /app/package.json ./
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

ENV PORT=8080

EXPOSE 8080

HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1

# It will be started by Deployment command
CMD ["andromeda", "dist/app.js" ]