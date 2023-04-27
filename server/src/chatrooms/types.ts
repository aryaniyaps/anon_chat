export type ChatRoom = {
  id: string;
  name: string;
  createdAt: Date;
  messages: Message[];
};

export type Message = {
  id: string;
  roomId: string;
  ownerId: string;
  content: string;
  createdAt: Date;
};
