import { v4 as uuidv4 } from 'uuid';

type User = {
  id: string;
  username: string;
  createdAt: Date;
};

const users = <User[]>[];

type ChatRoom = {
  id: string;
  name: string;
  createdAt: Date;
  onlineCount: number;
  enabled: boolean;
};

const chatrooms = <ChatRoom[]>[];

export function addUser(data: { username: string }): void {
  users.push({ id: uuidv4(), username: data.username, createdAt: new Date() });
}

export function updateUser(userId: string, data: { username: string }): void {
  // update user here
}

export function addChatroom(data: { name: string }): void {
  chatrooms.push({
    id: uuidv4(),
    name: data.name,
    createdAt: new Date(),
    onlineCount: 0,
    enabled: true
  });
}
