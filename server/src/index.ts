import { createServer, Server } from 'node:http';

import Koa from 'koa';
import bodyParser from 'koa-bodyparser';
import WebSocket from 'ws';

import router from './chatrooms/router';
import errorHandler from './core/middleware/error-handler';
import { registerEvents } from './core/pubsub';

function main(): void {
  const app = createApp();
  const server = createServer(app.callback());
  createWSServer(server);
  server.listen(parseInt(process.env.PORT!), () => {
    console.log(`🚀 listening at ${process.env.PORT!}`);
  });
}

function createApp(): Koa {
  const app = new Koa();
  app.use(bodyParser());
  app.use(errorHandler);
  registerRoutes(app);
  return app;
}

function createWSServer(server: Server): void {
  const ws = new WebSocket.Server({ server });
  registerEvents(ws);
}

function registerRoutes(app: Koa): void {
  app.use(router.routes()).use(router.allowedMethods());
}

main();
