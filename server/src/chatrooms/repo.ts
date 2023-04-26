import { v4 } from 'uuid';

import { ChatRoom } from './types';

const chatRooms = new Map<string, ChatRoom>();

function addChatRoom(data: { name: string }): void {
  const roomId = v4();
  chatRooms.set(roomId, {
    id: roomId,
    name: data.name
  });
}

function getChatRooms(): ChatRoom[] {
  return [];
}

function getChatRoom(data: { roomId: string }): ChatRoom {
  return chatRooms.get(data.roomId)!;
}

export default {
  addChatRoom,
  getChatRoom,
  getChatRooms
};
