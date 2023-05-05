declare namespace NodeJS {
  export interface ProcessEnv {
    PORT: string;
    SECRET_KEY: string;
    REDIS_URL: string;
  }
}
