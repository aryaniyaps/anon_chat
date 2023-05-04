class BaseError extends Error {
  constructor(data: { message: string }) {
    super(data.message);
  }
}

export class ResourceNotFound extends BaseError {}
