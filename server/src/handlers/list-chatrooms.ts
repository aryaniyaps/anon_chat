import { Socket } from 'socket.io';
import { ValidationError, object } from 'yup';

import { chatrooms } from '../data';

const schema = object({});

export default async function listChatrooms(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  try {
    await schema.validate(payload);
    callback({
      status: 'OK',
      data: chatrooms
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
