import { Server, Socket } from 'socket.io';

import createChatroom from './handlers/create-chatroom';
import createMessage from './handlers/create-message';
import joinChatroom from './handlers/join-chatroom';
import listChatrooms from './handlers/list-chatrooms';
import listMessages from './handlers/list-messages';
import loginUser from './handlers/login-user';

const io = new Server();

io.on('connection', (socket) => {
  console.log(`${socket.id} connected`);
  registerEventHandlers(socket);
});

function registerEventHandlers(socket: Socket): void {
  socket.on('users:login', loginUser);
  socket.on('chatrooms:create', createChatroom);
  socket.on('chatrooms:list', listChatrooms);
  socket.on('chatrooms:join', joinChatroom);
  socket.on('messages:list', listMessages);
  socket.on('messages:create', createMessage);
}

const port = process.env['PORT']!;

io.listen(parseInt(port));
console.log(`listening at ${port} 🚀`);
