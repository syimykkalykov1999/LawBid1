# LawBid test server image. Build context is the `lawbid/` folder (the server
# also needs shared/localization). Not for production: production is built
# from scratch at launch (docs/TZ.md, stage 5).
FROM node:22-alpine AS build
ENV NODE_OPTIONS=--max-old-space-size=3072
WORKDIR /app/backend
COPY backend/package.json backend/package-lock.json ./
RUN npm ci --legacy-peer-deps --no-audit --no-fund
COPY backend/ ./
RUN npx prisma generate && npx nest build

FROM node:22-alpine
ENV NODE_ENV=development
WORKDIR /app/backend
COPY --from=build /app/backend/node_modules ./node_modules
COPY --from=build /app/backend/dist ./dist
COPY --from=build /app/backend/prisma ./prisma
COPY --from=build /app/backend/assets ./assets
COPY --from=build /app/backend/scripts ./scripts
COPY --from=build /app/backend/package.json ./package.json
COPY shared/localization /app/shared/localization
EXPOSE 3000
CMD ["sh", "-c", "node scripts/test-server-bootstrap.mjs && node dist/src/main.js"]
