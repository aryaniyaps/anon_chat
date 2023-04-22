import Joi from 'joi';
import { getMessages } from '../repo';

const schema = Joi.object({
  roomId: Joi.string().uuid()
});

export default function listMessages(payload: any, callback: CallableFunction) {
  const { error, value } = schema.validate(payload);
  if (error) {
    return callback({
      status: 'Invalid Payload',
      error
    });
  }

  const messages = getMessages({
    roomId: value.roomId
  });

  callback({
    status: 'OK',
    data: messages
  });
}
