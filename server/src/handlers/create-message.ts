import Joi from 'joi';
import { addMessage } from '../repo';

const schema = Joi.object({
  roomId: Joi.string().uuid(),
  content: Joi.string().max(25).required(),
  ownerId: Joi.string().uuid()
});

export default function createMessage(
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

  const message = addMessage({
    roomId: value.roomId,
    content: value.content,
    ownerId: value.ownerId
  });

  callback({
    status: 'OK',
    data: message
  });
}
