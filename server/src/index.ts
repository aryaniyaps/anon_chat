import { nanoid } from 'nanoid';
import http from 'node:http';
import { Server } from 'socket.io';
import { addUser } from './repo';

const server = http.createServer();

const io = new Server(server);

io.on('connection', (socket) => {
  console.log('a user connected');

  socket.on('disconnect', () => {
    console.log('a user disconnected');
  });

  const username = nanoid();
  // send initial user ID
  socket.send(
    JSON.stringify({
      userId: nanoid()
    })
  );

  // save user
  addUser({ username });

  socket.on('message', (data) => {
    const packet = JSON.parse(data);

    switch (packet.command) {
      case 'regenerate-userid':
        socket.send(
          JSON.stringify({
            userId: nanoid()
          })
        );
        break;

      case 'create-chatroom':
        break;

      case 'create-message':
        break;

      case 'update-message':
        break;

      default:
        socket.send(
          JSON.stringify({
            message: 'incorrect command.'
          })
        );
    }
  });
});

console.log('Hello word!');

server.listen(3000, () => {
  console.log('listening at 3000');
});
