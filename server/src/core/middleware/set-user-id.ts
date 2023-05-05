import { Context, Next } from 'koa';
import { nanoid } from 'nanoid';

async function setUserId(ctx: Context, next: Next) {
  var userId = ctx.session!.userId;
  if (!userId) {
    userId = nanoid(16);
    ctx.session!.userId = userId;
  }
  await next();
}

export default setUserId;
