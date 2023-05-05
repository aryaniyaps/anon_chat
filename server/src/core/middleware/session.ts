import Koa from 'koa';
import redisStore from 'koa-redis';
import koaSession from 'koa-session';

export default function session(app: Koa) {
  return koaSession(
    {
      key: process.env.SECRET_KEY!,
      store: redisStore({
        url: process.env.REDIS_URL!
      })
    },
    app
  );
}
