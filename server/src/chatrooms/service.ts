import repo from './repo';
import { ChatRoom } from './types';

async function addChatRoom(input: { name: string }): Promise<void> {
  repo.addChatRoom({ name: input.name });
  // pub message
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
}
export default {
  addChatRoom,
  getChatRoom,
  getChatRooms,
  addMessage
};
