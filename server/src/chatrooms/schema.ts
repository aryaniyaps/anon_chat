import { number, object, string } from 'yup';

export const getChatRoomsSchema = object({
  take: number().positive().default(10),
  after: string()
});

export const getMessagesSchema = object({
  take: number().positive().default(10),
  after: string()
});

export const addChatRoomSchema = object({
  name: string().max(25).required()
});

export const addMessageSchema = object({
  content: string().max(250).required()
});
