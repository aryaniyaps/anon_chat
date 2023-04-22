import Joi from 'joi';
import { addChatroom } from '../repo';

const schema = Joi.object({
  name: Joi.string().max(25).required()
});

export default function createChatRoom(
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

  const chatroom = addChatroom({ name: value.name });
  callback({
    status: 'OK',
    data: chatroom
  });
}
