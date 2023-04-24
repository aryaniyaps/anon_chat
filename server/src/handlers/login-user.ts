import { Socket } from 'socket.io';
import { ValidationError, object, string } from 'yup';

const schema = object({
  username: string().max(25).required()
});

export default async function loginUser(
  this: Socket,
  payload: any,
  callback: CallableFunction
) {
  try {
    const data = await schema.validate(payload);
    this.data.username = data.username;
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