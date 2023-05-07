import Router from '@koa/router';

import repo from './repo';

const router = new Router({ prefix: '/users' });

router.get('/@me', async (ctx) => {
  const userInfo = {
    userId: ctx.session!.userId
  };
  ctx.body = userInfo;
});

router.post('/regen-id', async (ctx) => {
  const userId = repo.generateUserId();
  ctx.session!.userId = userId;
  const userInfo = {
    userId
  };
  ctx.body = userInfo;
});

export default router;
