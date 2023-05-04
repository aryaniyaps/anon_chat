import Redis from 'ioredis';
import WebSocket, { WebSocketServer } from 'ws';

const publisher = new Redis(process.env.REDIS_URL!);

const subscriber = publisher.duplicate();

function registerEvents(ws: WebSocketServer): void {
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
  subscriber.subscribe('chatrooms:create');
  subscriber.subscribe('messages:create');
  subscriber.subscribe('test');
  publisher.publish('test', JSON.stringify('test message'));
}

export { publisher, registerEvents };
