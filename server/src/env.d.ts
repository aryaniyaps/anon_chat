declare namespace NodeJS {
  export interface ProcessEnv {
    PORT: string;
    SECRET_KEY: string;
    DATABASE_URL: string;
    REDIS_URL: string;
    PUSHER_APP_KEY: string;
    PUSHER_APP_ID: string;
    PUSHER_APP_SECRET: string;
    PUSHER_HOST: string;
  }
}
