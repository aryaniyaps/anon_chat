import Redis from 'ioredis';
import { Server } from 'socket.io';

const publisher = new Redis(process.env.REDIS_URL!);

const subscriber = publisher.duplicate();

// subscribe to events

function registerEvents(server: Server): void {
  subscriber.on('message', function (channel, message) {
    console.log(channel, message);
    server.emit(channel, message);
  });
  publisher.publish('test', 'test message');
}

export { publisher, registerEvents };
