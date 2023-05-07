import { number, object, string } from 'yup';

export const getChatRoomsSchema = object({
  // hack: "" is parsed to NaN
  take: number()
    .transform((value) => (isNaN(value) ? undefined : value))
    .default(10)
    .positive(),
  after: string()
});

export const getMessagesSchema = object({
  // hack: "" is parsed to NaN
  take: number()
    .transform((value) => (isNaN(value) ? undefined : value))
    .default(10)
    .positive(),
  after: string()
});

export const addChatRoomSchema = object({
  name: string().max(25).required()
});

export const addMessageSchema = object({
  content: string().max(250).required()
});
