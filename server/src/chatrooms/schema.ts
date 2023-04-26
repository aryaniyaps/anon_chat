import { object, string } from 'yup';

export const addChatRoomSchema = object({
  name: string().max(25).required()
});

export const addMessageSchema = object({
  content: string().max(250).required()
});
