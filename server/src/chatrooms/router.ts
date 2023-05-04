import Router from '@koa/router';

import { addChatRoomSchema, addMessageSchema } from './schema';
import service from './service';

const router = new Router({ prefix: '/chatrooms' });

router.get('/', async (ctx) => {
  const chatRooms = await service.getChatRooms();
  ctx.body = chatRooms;
});

router.post('/', async (ctx) => {
  const data = await addChatRoomSchema.validate(ctx.request.body);
  const chatRoom = await service.addChatRoom({ name: data.name });
  ctx.body = chatRoom;
});

router.get('/:id', async (ctx) => {
  const roomId = ctx.params.id;
  const chatRoom = await service.getChatRoom({ roomId });
  ctx.body = chatRoom;
});

router.post('/:id/messages', async (ctx) => {
  const roomId = ctx.params.id;
  const data = await addMessageSchema.validate(ctx.request.body);
  const message = await service.addMessage({
    roomId,
    content: data.content
  });
  ctx.body = message;
});

export default router;
