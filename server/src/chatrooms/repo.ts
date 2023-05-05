import type { ChatRoom, Message } from '@prisma/client';

import { prisma } from '../core/database';
import { ResourceNotFound } from '../core/errors';

async function addChatRoom(data: { name: string }): Promise<ChatRoom> {
  return await prisma.chatRoom.create({ data });
}

async function addMessage(data: {
  content: string;
  userId: string;
  roomId: string;
}): Promise<Message> {
  // check if chatroom is valid
  return await prisma.message.create({
    data: {
      content: data.content,
      chatRoomId: data.roomId,
      userId: data.userId
    }
  });
}

async function getMessages(data: { roomId: string }) {
  // check if chatroom is valid
  return await prisma.message.findMany({
    where: { chatRoomId: data.roomId },
    orderBy: [{ createdAt: 'desc' }]
  });
}

async function getChatRooms(): Promise<ChatRoom[]> {
  return await prisma.chatRoom.findMany({ orderBy: [{ createdAt: 'desc' }] });
}

async function getChatRoom(data: { roomId: string }): Promise<ChatRoom> {
  const chatRoom = await prisma.chatRoom.findFirst({
    where: { id: data.roomId }
  });
  if (!chatRoom) {
    throw new ResourceNotFound({
      message: `ChatRoom with ID ${data.roomId} not found.`
    });
  }
  return chatRoom;
}

export default {
  addChatRoom,
  addMessage,
  getMessages,
  getChatRoom,
  getChatRooms
};
