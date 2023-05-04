import { v4 } from 'uuid';

import { ResourceNotFound } from '../core/errors';
import { ChatRoom, Message } from './types';

const chatRooms = new Map<string, ChatRoom>();

function addChatRoom(data: { name: string }): ChatRoom {
  const chatRoom: ChatRoom = {
    id: v4(),
    name: data.name,
    createdAt: new Date(),
    messages: []
  };
  chatRooms.set(chatRoom.id, chatRoom);
  return chatRoom;
}

function addMessage(data: {
  content: string;
  roomId: string;
  ownerId: string;
}): Message {
  const chatRoom = getChatRoom({ roomId: data.roomId });
  const message: Message = {
    id: v4(),
    roomId: data.roomId,
    ownerId: data.roomId,
    content: data.content,
    createdAt: new Date()
  };
  chatRoom.messages.push(message);
  return message;
}

function getChatRooms(): ChatRoom[] {
  return Array.from(chatRooms, ([_, chatRoom]) => chatRoom);
}

function getChatRoom(data: { roomId: string }): ChatRoom {
  const chatRoom = chatRooms.get(data.roomId);
  if (!chatRoom) {
    throw new ResourceNotFound({
      message: `ChatRoom with ID ${data.roomId} not found.`
    });
  }
  return chatRoom;
}

// populate chatrooms
addChatRoom({ name: 'ChatRoom 1' });

addChatRoom({ name: 'ChatRoom 2' });

addChatRoom({ name: 'ChatRoom 3' });

export default {
  addChatRoom,
  addMessage,
  getChatRoom,
  getChatRooms
};
