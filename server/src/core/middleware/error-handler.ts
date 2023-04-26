import { Context, Next } from 'koa';
import { ValidationError } from 'yup';

async function errorHandler(ctx: Context, next: Next) {
  try {
    await next();
  } catch (error) {
    if (error instanceof ValidationError) {
      // 422 Unprocessable Entity
      ctx.status = 422;
      ctx.body = {
        message: 'Invalid payload.',
        errors: error.errors
      };
    } else {
      // 500 Internal Server Error
      ctx.status = 500;
      ctx.body = {
        message: 'Unexpected error occured.'
      };
    }
  }
}

export default errorHandler;
