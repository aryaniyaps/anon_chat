import { v4 } from 'uuid';

import { ChatRoom } from './types';

const chatRooms = new Map<string, ChatRoom>();

function addChatRoom(data: { name: string }): ChatRoom {
  const chatRoom: ChatRoom = {
    id: v4(),
    name: data.name
  };
  chatRooms.set(chatRoom.id, chatRoom);
  return chatRoom;
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
