
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# If backend is TS:
# RUN npm run build
# Otherwise skip build if pure JS
# Expose port via env at runtime

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app ./
# If built to /dist, adjust start command accordingly
EXPOSE 5000
CMD ["npm","start"]
