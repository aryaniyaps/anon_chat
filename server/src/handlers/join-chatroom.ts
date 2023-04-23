import { Socket } from 'socket.io';
import { ValidationError, object, string } from 'yup';

import { chatrooms } from '../data';

const schema = object({
  roomId: string().uuid().required()
});

export default async function joinChatroom(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  try {
    const data = await schema.validate(payload);
    const chatroom = chatrooms.get(data.roomId)!;

    // join room
    this.join(chatroom.id);

    callback({
      status: 'OK'
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
