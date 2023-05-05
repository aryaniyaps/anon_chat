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
  userId: string;
  roomId: string;
}): Promise<Message> {
  const message = await repo.addMessage({
    content: input.content,
    roomId: input.roomId,
    userId: input.userId
  });
  // pub message
  publisher.publish('messages:create', JSON.stringify(message));
  return message;
}

async function getMessages(input: { roomId: string }) {
  return await repo.getMessages({ roomId: input.roomId });
}

export default {
  addChatRoom,
  getChatRoom,
  getChatRooms,
  addMessage,
  getMessages
};
