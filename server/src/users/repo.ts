import { nanoid } from 'nanoid';

function generateUserId() {
  // return a random & slightly readable string
  return nanoid(16);
}

export default { generateUserId };
