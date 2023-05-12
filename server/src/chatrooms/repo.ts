import type { ChatRoom, Message } from '@prisma/client';

import { prisma } from '../core/database';
import { ResourceNotFound } from '../core/errors';
import { PaginateOpts, Paginated, paginate } from '../core/paginator';

async function addChatRoom(data: { name: string }): Promise<ChatRoom> {
  return await prisma.chatRoom.create({ data });
}

async function addMessage(data: {
  content: string;
  userId: string;
  roomId: string;
}): Promise<Message> {
  return await prisma.message.create({
    data: {
      content: data.content,
      chatRoomId: data.roomId,
      userId: data.userId
    }
  });
}

async function getMessages(
  data: {
    roomId: string;
  },
  opts: PaginateOpts<string>
): Promise<Paginated<Message, string>> {
  return await paginate(
    (args) =>
      prisma.message.findMany({
        ...args,
        where: { chatRoomId: data.roomId },
        orderBy: { createdAt: 'desc' }
      }),
    opts
  );
}

async function getChatRooms(
  data: { search?: string },
  opts: PaginateOpts<string>
): Promise<Paginated<ChatRoom, string>> {
  return await paginate(
    (args) =>
      prisma.chatRoom.findMany({
        ...args,
        where: { name: { search: data.search } },
        orderBy: { createdAt: 'desc' }
      }),
    opts
  );
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
