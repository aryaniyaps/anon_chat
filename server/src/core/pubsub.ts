import { createClient } from 'redis';

const client = createClient();

const subscriber = client.duplicate();

// subscribe to events

export { client, subscriber };
