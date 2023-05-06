import Router from '@koa/router';

import {
  addChatRoomSchema,
  addMessageSchema,
  getChatRoomsSchema
} from './schema';
import service from './service';

const router = new Router({ prefix: '/chatrooms' });

router.get('/', async (ctx) => {
  const data = await getChatRoomsSchema.validate(ctx.query);
  const chatRooms = await service.getChatRooms({
    take: data.take,
    after: data.after
  });
  ctx.body = chatRooms;
});

router.post('/', async (ctx) => {
  const data = await addChatRoomSchema.validate(ctx.body);
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
  const data = await addMessageSchema.validate(ctx.body);
  const message = await service.addMessage({
    roomId,
    content: data.content,
    userId: ctx.session!.userId
  });
  ctx.body = message;
});

router.get('/:id/messages', async (ctx) => {
  const roomId = ctx.params.id;
  const data = await getChatRoomsSchema.validate(ctx.query);
  const messages = await service.getMessages({
    roomId,
    take: data.take,
    after: data.after
  });
  ctx.body = messages;
});

export default router;
