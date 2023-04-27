import { publisher } from '../core/pubsub';
import repo from './repo';
import { ChatRoom, Message } from './types';

function addChatRoom(input: { name: string }): ChatRoom {
  const chatRoom = repo.addChatRoom({ name: input.name });
  publisher.publish('chatrooms:create', JSON.stringify(chatRoom));
  return chatRoom;
}

function getChatRooms(): ChatRoom[] {
  return repo.getChatRooms();
}

function getChatRoom(input: { roomId: string }): ChatRoom {
  return repo.getChatRoom({ roomId: input.roomId });
}

function addMessage(input: {
  content: string;
  ownerId: string;
  roomId: string;
}): Message {
  const message = repo.addMessage({
    content: input.content,
    ownerId: input.ownerId,
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
