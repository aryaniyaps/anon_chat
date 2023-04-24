import 'dotenv-safe/config';

import { createServer } from 'node:http';

import { Server, Socket } from 'socket.io';

import createChatroom from './handlers/create-chatroom';
import createMessage from './handlers/create-message';
import joinChatroom from './handlers/join-chatroom';
import leaveChatroom from './handlers/leave-chatroom';
import listChatrooms from './handlers/list-chatrooms';
import listMessages from './handlers/list-messages';
import loginUser from './handlers/login-user';

const server = createServer();
const io = new Server(server);

io.on('connection', (socket) => {
  console.log(`💡 socket ${socket.id} connected`);
  socket.on('disconnect', () => {
    console.log(`⭕ socket ${socket.id} disconnected`);
  });
  registerMiddleware(socket);
  registerEventHandlers(socket);
});

function registerEventHandlers(socket: Socket): void {
  socket.on('users:login', loginUser);
  socket.on('chatrooms:create', createChatroom);
  socket.on('chatrooms:list', listChatrooms);
  socket.on('chatrooms:join', joinChatroom);
  socket.on('chatrooms:leave', leaveChatroom);
  socket.on('messages:list', listMessages);
  socket.on('messages:create', createMessage);
}

function registerMiddleware(socket: Socket): void {}

server.listen(parseInt(process.env.PORT!), () => {
  console.log(`🚀 listening at ${process.env.PORT!}`);
});
