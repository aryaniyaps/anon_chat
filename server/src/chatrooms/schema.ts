import { number, object, string } from 'yup';

export const getChatRoomsSchema = object({
  // hack: "" is parsed to NaN
  limit: number()
    .transform((value) => (isNaN(value) ? undefined : value))
    .default(25)
    .positive(),
  before: string()
});

export const getMessagesSchema = object({
  // hack: "" is parsed to NaN
  limit: number()
    .transform((value) => (isNaN(value) ? undefined : value))
    .default(25)
    .positive(),
  before: string()
});

export const addChatRoomSchema = object({
  name: string().required().max(25)
});

export const addMessageSchema = object({
  content: string().required().max(250)
});
