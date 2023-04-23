import Joi from 'joi';
import { Socket } from 'socket.io';

const schema = Joi.object({
  username: Joi.string().max(25).required()
});

export default function loginUser(
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

  callback({
    status: 'OK'
  });
}
