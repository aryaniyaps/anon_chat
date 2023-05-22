import { number, object, string } from 'yup';

export const getChatRoomsSchema = object({
  limit: number().default(25).positive(),
  before: string(),
  search: string().max(50)
});

export const getMessagesSchema = object({
  limit: number().default(25).positive(),
  before: string()
});

export const addChatRoomSchema = object({
  name: string().required().max(25)
});

export const addMessageSchema = object({
  content: string().required().max(250)
});
