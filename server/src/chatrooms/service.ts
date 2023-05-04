import type { ChatRoom, Message } from '@prisma/client';
import { publisher } from '../core/pubsub';
import repo from './repo';

async function addChatRoom(input: { name: string }): Promise<ChatRoom> {
  const chatRoom = await repo.addChatRoom({ name: input.name });
  publisher.publish('chatrooms:create', JSON.stringify(chatRoom));
  return chatRoom;
}

async function getChatRooms(): Promise<ChatRoom[]> {
  return await repo.getChatRooms();
}

async function getChatRoom(input: { roomId: string }): Promise<ChatRoom> {
  return await repo.getChatRoom({ roomId: input.roomId });
}

async function addMessage(input: {
  content: string;
  roomId: string;
}): Promise<Message> {
  const message = await repo.addMessage({
    content: input.content,
    roomId: input.roomId
  });
  // pub message
  publisher.publish('messages:create', JSON.stringify(message));
  return message;
}
export default {
  addChatRoom,
  getChatRoom,
  getChatRooms,
  addMessage
};
