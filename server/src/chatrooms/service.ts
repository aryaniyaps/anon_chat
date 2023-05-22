import type { ChatRoom, Message } from '@prisma/client';
import { PaginateOpts } from '../core/paginator';
import { publisher } from '../core/pubsub';
import repo from './repo';

async function addChatRoom(input: { name: string }): Promise<ChatRoom> {
  return await repo.addChatRoom({ name: input.name });
}

async function getChatRooms(
  input: { search?: string },
  opts: PaginateOpts<string>
) {
  return await repo.getChatRooms(input, opts);
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
  await publisher.publish('messages:create', JSON.stringify(message));
  return message;
}

async function getMessages(
  input: {
    roomId: string;
  },
  opts: PaginateOpts<string>
) {
  return await repo.getMessages(
    {
      roomId: input.roomId
    },
    opts
  );
}

export default {
  addChatRoom,
  getChatRoom,
  getChatRooms,
  addMessage,
  getMessages
};
