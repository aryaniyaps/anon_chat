FROM node:18 as build

ARG APP_HOME=/server/
WORKDIR ${APP_HOME}

COPY package.json package-lock.json ./

FROM build as development

# install dependencies
RUN npm install

COPY . .

EXPOSE 3000

CMD npm run start:dev

FROM build as production

# install dependencies (omit dev deps)
# directly install from package-lock.json
RUN npm ci --omit=dev

COPY . .

EXPOSE 3000

CMD npm run start