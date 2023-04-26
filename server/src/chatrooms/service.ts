import { publisher } from '../core/pubsub';
import repo from './repo';
import { ChatRoom } from './types';

async function addChatRoom(input: { name: string }): Promise<void> {
  const chatRoom = repo.addChatRoom({ name: input.name });
  publisher.publish('chatrooms:create', JSON.stringify(chatRoom));
}

function getChatRooms(): ChatRoom[] {
  return repo.getChatRooms();
}

function getChatRoom(input: { roomId: string }): ChatRoom {
  return repo.getChatRoom({ roomId: input.roomId });
}

async function addMessage(input: {
  content: string;
  ownerId: string;
  roomId: string;
}): Promise<void> {
  // pub message
  publisher.publish('messages:create', JSON.stringify(input));
}
export default {
  addChatRoom,
  getChatRoom,
  getChatRooms,
  addMessage
};
