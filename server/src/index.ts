import 'dotenv-safe/config';

import { createServer, Server } from 'node:http';

import Koa from 'koa';
import bodyParser from 'koa-bodyparser';
import { Server as SocketIOServer } from 'socket.io';

import router from './chatrooms/router';
import errorHandler from './core/middleware/error-handler';
import { registerEvents } from './core/pubsub';

function main(): void {
  const app = createApp();
  const httpServer = createServer(app.callback());
  createSocketIOServer(httpServer);
  httpServer.listen(parseInt(process.env.PORT!), () => {
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

function createSocketIOServer(httpServer: Server): SocketIOServer {
  const io = new SocketIOServer(httpServer);
  registerEvents(io);
  return io;
}

function registerRoutes(app: Koa): void {
  app.use(router.routes()).use(router.allowedMethods());
}

main();
