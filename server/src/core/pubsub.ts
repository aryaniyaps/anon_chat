import { createClient } from 'redis';
import { Server } from 'socket.io';

const publisher = createClient();

const subscriber = publisher.duplicate();

// subscribe to events

function registerEvents(server: Server): void {
  subscriber.on('message', function (channel, message) {
    server.emit(channel, message);
  });
}

export { publisher, registerEvents };
