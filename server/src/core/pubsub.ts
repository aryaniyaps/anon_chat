import Redis from 'ioredis';
import { Server, WebSocket } from 'ws';

const publisher = new Redis(process.env.REDIS_URL!);

const subscriber = publisher.duplicate();

function registerSubscribers(ws: Server): void {
  subscriber.on('message', function (channel, message) {
    // message is JSON stringified
    // channel is the type of event
    const content = JSON.parse(message);
    ws.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify({ type: channel, data: content }));
      }
    });
    ws.emit(channel, content);
  });
  subscriber.subscribe('messages:create');
}

export { publisher, registerSubscribers };
