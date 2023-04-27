import Router from '@koa/router';

import { addChatRoomSchema, addMessageSchema } from './schema';
import service from './service';

const router = new Router({ prefix: '/chatrooms' });

router.get('/', (ctx) => {
  const chatRooms = service.getChatRooms();
  ctx.body = chatRooms;
});

router.post('/', async (ctx) => {
  const data = await addChatRoomSchema.validate(ctx.request.body);
  const chatRoom = service.addChatRoom({ name: data.name });
  ctx.body = chatRoom;
});

router.get('/:id', (ctx) => {
  const roomId = ctx.params.id;
  const chatRoom = service.getChatRoom({ roomId });
  ctx.body = chatRoom;
});

router.post('/:id/messages', async (ctx) => {
  const roomId = ctx.params.id;
  const data = await addMessageSchema.validate(ctx.request.body);
  const message = service.addMessage({
    roomId,
    content: data.content,
    ownerId: ''
  });
  ctx.body = message;
});

export default router;
