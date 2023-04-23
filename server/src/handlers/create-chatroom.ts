import { Socket } from 'socket.io';
import { ValidationError, object, string } from 'yup';

import { v4 } from 'uuid';
import { ChatRoom, chatrooms } from '../data';

const schema = object({
  name: string().max(25).required()
});

export default async function createChatroom(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  try {
    const data = await schema.validate(payload);

    // create chatroom
    const chatroom: ChatRoom = {
      id: v4(),
      name: data.name,
      messages: []
    };
    chatrooms.set(chatroom.id, chatroom);

    callback({
      status: 'OK',
      data: chatroom
    });
  } catch (error) {
    if (error instanceof ValidationError) {
      return callback({
        status: 'Invalid Payload',
        message: error.message,
        errors: error.errors
      });
    }
  }
}
