import Joi from 'joi';
import { addUser } from '../repo';

const schema = Joi.object({
  username: Joi.string().max(25).required()
});

export default function createUser(payload: any, callback: CallableFunction) {
  const { error, value } = schema.validate(payload);
  if (error) {
    return callback({
      status: 'Invalid Payload',
      error
    });
  }

  const user = addUser({ username: value.username });
  callback({
    status: 'OK',
    data: user
  });
}
