import Joi from 'joi';
import { generateUsername } from '../repo';

const schema = Joi.object({});

export default function refreshUsername(
  payload: any,
  callback: CallableFunction
) {
  const { error } = schema.validate(payload);
  if (error) {
    return callback({
      status: 'Invalid Payload',
      error
    });
  }

  const username = generateUsername();
  callback({
    status: 'OK',
    data: username
  });
}
