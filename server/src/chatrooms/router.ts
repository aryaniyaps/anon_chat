import Router from '@koa/router';

import {
  addChatRoomSchema,
  addMessageSchema,
  getChatRoomsSchema,
  getMessagesSchema
} from './schema';
import service from './service';

const router = new Router({ prefix: '/chatrooms' });

router.get('/', async (ctx) => {
  const data = await getChatRoomsSchema.validate(ctx.request.query);
  const chatRooms = await service.getChatRooms({
    limit: data.limit,
    before: data.before
  });
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
    content: data.content,
    userId: ctx.session!.userId
  });
  ctx.body = message;
});

router.get('/:id/messages', async (ctx) => {
  const roomId = ctx.params.id;
  const data = await getMessagesSchema.validate(ctx.request.query);
  const messages = await service.getMessages(
    {
      roomId
    },
    { limit: data.limit, before: data.before }
  );
  ctx.body = messages;
});

export default router;
