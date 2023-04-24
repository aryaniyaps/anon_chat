import { Socket } from 'socket.io';
import { v4 } from 'uuid';
import { ValidationError, object, string } from 'yup';

import { Message, chatrooms } from '../data';

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
    const chatroom = chatrooms.get(data.roomId);

    if (!chatroom) {
      return callback({
        status: 'Invalid Payload',
        message: `Chatroom with ID ${data.roomId} doesn't exist.`
      });
    }

    // join room
    this.join(chatroom.id);

    // emit message
    const message: Message = {
      id: v4(),
      content: `${this.data.username} entered the room.`,
      chatroomId: chatroom.id,
      isServer: true
    };
    this.to(chatroom.id).emit('messages:create', message);

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
