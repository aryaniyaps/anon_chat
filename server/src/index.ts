import http from 'node:http';
import { Server } from 'socket.io';

const server = http.createServer();

const io = new Server(server);

io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('a user disconnected');
  });
});

console.log('Hello word!');

server.listen(3000, () => {
  console.log('listening at 3000');
});
