import { Server, Socket } from 'socket.io';

import loginUser from './handlers/login-user';

const io = new Server();

io.on('connection', (socket) => {
  console.log(`${socket.id} connected`);
  registerEventHandlers(socket);
});

function registerEventHandlers(socket: Socket): void {
  socket.on('users:login', loginUser);
}

io.listen(3000);
console.log('listening at 3000 🚀');
