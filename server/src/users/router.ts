import Router from '@koa/router';

const router = new Router({ prefix: '/users' });

router.get('/@me', async (ctx) => {
  const userInfo = {
    userId: ctx.session!.userId
  };
  ctx.body = userInfo;
});

export default router;
