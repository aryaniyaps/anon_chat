import { nanoid } from 'nanoid';
import { v4 } from 'uuid';

type User = {
  id: string;
  username: string;
  createdAt: Date;
};

const users = new Map<string, User>();

type Message = {
  id: string;
  roomId: string;
  content: string;
  createdAt: Date;
  ownerId: string;
};

type ChatRoom = {
  id: string;
  name: string;
  createdAt: Date;
  onlineCount: number;
  enabled: boolean;
  messages: Message[];
};

const chatrooms = new Map<string, ChatRoom>();

export function addUser(data: { username: string }): User {
  const user: User = {
    id: v4(),
    username: data.username,
    createdAt: new Date()
  };
  users.set(user.id, user);
  return user;
}

export function generateUsername(): string {
  // todo: maybe return readable, beautiful usernames later
  return nanoid();
}

export function addChatroom(data: { name: string }): ChatRoom {
  const chatroom: ChatRoom = {
    id: v4(),
    name: data.name,
    createdAt: new Date(),
    onlineCount: 0,
    enabled: true,
    messages: []
  };
  chatrooms.set(chatroom.id, chatroom);
  return chatroom;
}

export function addMessage(data: {
  roomId: string;
  content: string;
  ownerId: string;
}): Message {
  const chatroom = chatrooms.get(data.roomId)!;
  const message: Message = {
    id: v4(),
    roomId: data.roomId,
    content: data.content,
    createdAt: new Date(),
    ownerId: data.ownerId
  };
  chatroom.messages.push(message);
  return message;
}

export function getMessages(data: { roomId: string }): Message[] {
  const chatroom = chatrooms.get(data.roomId)!;
  return chatroom.messages;
}
