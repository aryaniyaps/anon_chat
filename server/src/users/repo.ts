import { nanoid } from 'nanoid';

function generateUserId() {
  // return a random & slightly readable string
  return nanoid(10);
}

export default { generateUserId };
