import { Context, Next } from 'koa';
import { ValidationError } from 'yup';
import { ResourceNotFound } from '../errors';

async function errorHandler(ctx: Context, next: Next) {
  try {
    await next();
  } catch (error) {
    if (error instanceof ValidationError) {
      // 422 Unprocessable Entity
      console.log(error);
      ctx.status = 422;
      ctx.body = {
        message: 'Invalid payload.',
        errors: error.errors
      };
    } else if (error instanceof ResourceNotFound) {
      // 404 Not Found
      ctx.status = 404;
      ctx.body = {
        message: error.message
      };
    } else {
      console.log('SERVER ERROR', error);
      // 500 Internal Server Error
      ctx.status = 500;
      ctx.body = {
        message: 'Unexpected error occured.'
      };
    }
  }
}

export default errorHandler;
