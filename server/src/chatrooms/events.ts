import { WebSocket } from 'ws';
import repo from './repo';
import { joinChatRoomSchema, leaveChatRoomSchema } from './schema';

// in memory map of chatrooms and connected clients
const rooms = new Map<string, WebSocket[]>();

async function joinChatRoom(socket: WebSocket, payload: any) {
  // validate payload
  const { roomId } = await joinChatRoomSchema.validate(payload);
  const chatRoom = await repo.getChatRoom({ roomId });
  const websockets = rooms.get(chatRoom.id);

  if (!websockets) {
    rooms.set(chatRoom.id, []);
  }

  rooms.get(chatRoom.id)!.push(socket);
}

async function leaveChatRoom(socket: WebSocket, payload: any) {
  // validate payload
  const { roomId } = await leaveChatRoomSchema.validate(payload);
  const chatRoom = await repo.getChatRoom({ roomId });

  // TODO: check if chatroom exists and kick socket
}

export default { joinChatRoom, leaveChatRoom };
