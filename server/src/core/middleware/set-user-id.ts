import { Context, Next } from 'koa';

import userRepo from '../../users/repo';

async function setUserId(ctx: Context, next: Next) {
  var userId = ctx.session!.userId;
  if (!userId) {
    userId = userRepo.generateUserId();
    ctx.session!.userId = userId;
  }
  await next();
}

export default setUserId;
