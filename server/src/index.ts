import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

wss.on('connection', (ws, req) => {
  ws.on('error', console.error);

  ws.on('message', (data) => {
    console.log('received: ', data);
  });

  const ipAddress = req.socket.remoteAddress;
  ws.send(`hello ${ipAddress}!`);
});
