import Router from '@koa/router';

import { addChatRoomSchema, addMessageSchema } from '../schemas';
import service from './service';

const router = new Router({ prefix: '/chatrooms' });

router.get('/', (ctx) => {
  const chatRooms = service.getChatRooms();
  ctx.body = {
    status: 'OK',
    data: chatRooms
  };
});

router.post('/', async (ctx) => {
  const data = await addChatRoomSchema.validate(ctx.request.body);
  service.addChatRoom({ name: data.name });
  ctx.body = {
    status: 'OK'
  };
});

router.get('/:id', (ctx) => {
  const roomId = ctx.params.id;
  const chatRoom = service.getChatRoom({ roomId });
  ctx.body = {
    status: 'OK',
    data: chatRoom
  };
});

router.post('/:id/messages', async (ctx) => {
  const roomId = ctx.params.id;
  const data = await addMessageSchema.validate(ctx.request.body);
  await service.addMessage({ roomId, content: data.content, ownerId: '' });
  // pub message
  ctx.body = {
    status: 'OK'
  };
});

export default router;
