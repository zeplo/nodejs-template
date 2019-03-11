FROM node:11.9.0-alpine as base

# Keep root clean
WORKDIR /app

# Allow env overwrite for image
ARG ENV=production

COPY ./package.json ./package.json
COPY ./yarn.lock ./yarn.lock

# Install (with linked local modules)
RUN yarn install --ignore-scripts

# Add SRC
COPY ./src ./src
COPY .babelrc .babelrc

# Build the files
RUN yarn build

FROM node:11.9.0-alpine

# Keep root clean
WORKDIR /app

COPY --from=base /app/dist ./dist
COPY ./package.json ./package.json
COPY ./yarn.lock ./yarn.lock

# Set to production, we can always overwrite this
ENV NODE_ENV ${ENV}

# Install (with linked local modules)
RUN yarn install --ignore-scripts

# Safe user
USER node

EXPOSE 3000

# Serve, for a pure execution
CMD node ./dist -s
