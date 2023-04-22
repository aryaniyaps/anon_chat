import { Server, Socket } from 'socket.io';

import createChatRoom from './handlers/create-chatroom';
import createMessage from './handlers/create-message';
import createUser from './handlers/create-user';
import joinChatroom from './handlers/join-chatroom';
import listMessages from './handlers/list-messages';
import refreshUsername from './handlers/refresh-username';

const io = new Server();

io.on('connection', (socket) => {
  console.log(`${socket.id} connected`);
  registerEventHandlers(socket);
});

function registerEventHandlers(socket: Socket): void {
  socket.on('username:refresh', refreshUsername);
  socket.on('users:create', createUser);
  socket.on('chatrooms:create', createChatRoom);
  socket.on('chatrooms:join', joinChatroom);
  socket.on('messages:list', listMessages);
  socket.on('messages:create', createMessage);
}

io.listen(3000);
console.log('listening at 3000 🚀');
