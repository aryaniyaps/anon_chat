type Message = {
  id: string;
  chatroomId: string;
  content: string;
  username: string;
};

type ChatRoom = {
  id: string;
  name: string;
  messages: Message[];
};

const chatrooms = new Map<string, ChatRoom>();

export { Message, ChatRoom, chatrooms };
