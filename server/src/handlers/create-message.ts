import { Socket } from 'socket.io';
import { ValidationError, object, string } from 'yup';

import { v4 } from 'uuid';
import { Message, chatrooms } from '../data';

const schema = object({
  roomId: string().uuid().required(),
  content: string().max(250).required()
});

export default async function createMessage(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  try {
    const data = await schema.validate(payload);
    const chatroom = chatrooms.get(data.roomId)!;

    // create message
    const message: Message = {
      id: v4(),
      content: data.content,
      chatroomId: chatroom.id,
      username: this.data.username
    };
    chatroom.messages.push(message);

    // broadcast message
    this.to(chatroom.id).emit('messages:create', message);

    callback({
      status: 'OK',
      data: message
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
