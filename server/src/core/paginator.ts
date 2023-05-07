interface PageInfo<T> {
  hasNextPage: boolean;
  cursor: T | undefined;
}

export interface PaginateArgs<T> {
  take: number;
  cursor?: { id: T };
  skip: number | undefined;
}

export interface PaginateOpts<T> {
  limit: number;
  before: T | undefined;
}

export interface Paginated<Model, T> {
  pageInfo: PageInfo<T>;
  entities: Model[];
}

export async function paginate<Model extends { id: T }, T>(
  findMany: (args: PaginateArgs<T>) => Promise<Model[]>,
  opts: PaginateOpts<T>
): Promise<Paginated<Model, T>> {
  // fetch an extra entity to determine if the next page exists
  const take = opts.limit + 1;

  const skip = opts.before ? 1 : undefined;

  const cursor = opts.before ? { id: opts.before } : undefined;

  // load entities from database
  const entities = await findMany({ cursor, take, skip });

  const hasNextPage = entities.length > opts.limit;

  let pagingCursor = undefined;

  if (hasNextPage) {
    // remove extra entity we fetched
    entities.pop();
    pagingCursor = entities[entities.length - 1].id;
  }

  return {
    pageInfo: {
      hasNextPage,
      cursor: pagingCursor
    },
    entities
  };
}
