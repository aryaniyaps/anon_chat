import Joi from 'joi';
import { Socket } from 'socket.io';

const schema = Joi.object({
  roomId: Joi.string().uuid()
});

export default function joinChatroom(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  const { error, value } = schema.validate(payload);
  if (error) {
    return callback({
      status: 'Invalid Payload',
      error
    });
  }

  this.join(value.roomId);
  // todo: update chatroom's online count
  return callback({ status: 'OK' });
}
