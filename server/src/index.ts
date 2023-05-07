import { createServer, Server } from 'node:http';

import Koa from 'koa';
import WebSocket from 'ws';

import chatRoomRouter from './chatrooms/router';
import bodyParser from './core/middleware/body-parser';
import errorHandler from './core/middleware/error-handler';
import session from './core/middleware/session';
import setUserId from './core/middleware/set-user-id';
import { registerEvents } from './core/pubsub';
import userRouter from './users/router';

function main(): void {
  const app = createApp();
  app.keys = ['secret-key-1', 'secret-key-2'];
  const server = createServer(app.callback());
  createWSServer(server);
  server.listen(parseInt(process.env.PORT!), () => {
    console.log(`🚀 listening at ${process.env.PORT!}`);
  });
}

function createApp(): Koa {
  const app = new Koa();
  registerMiddleware(app);
  registerRoutes(app);
  return app;
}

function createWSServer(server: Server): void {
  const ws = new WebSocket.Server({ server });
  registerEvents(ws);
}

function registerMiddleware(app: Koa): void {
  app.use(bodyParser);
  app.use(session(app));
  app.use(setUserId);
  app.use(errorHandler);
}

function registerRoutes(app: Koa): void {
  app.use(userRouter.routes()).use(userRouter.allowedMethods());
  app.use(chatRoomRouter.routes()).use(chatRoomRouter.allowedMethods());
}

main();
