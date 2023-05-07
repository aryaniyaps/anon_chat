interface PageInfo<T> {
  hasNextPage: boolean;
  cursor: T | undefined;
}

export interface PaginateArgs<T> {
  take: number;
  cursor: { id: T | undefined };
  skip?: number;
}

export interface PaginateOpts<T> {
  take: number;
  cursor: T | undefined;
  skip?: number;
}

export interface Paginated<Model, T> {
  pageInfo: PageInfo<T>;
  entities: Model[];
}

export async function paginate<Model extends { id: T }, T>(
  findMany: (args: PaginateArgs<T>) => Promise<Model[]>,
  opts: PaginateOpts<T>
): Promise<Paginated<Model, T>> {
  if (opts.take != null && opts.take < 0) {
    throw new Error('take is less than 0');
  }
  // fetch an extra entity to determine if the next page exists
  const take = opts.take++;

  const skip = opts.cursor ? 1 : undefined;

  // load entities from database
  const entities = await findMany({ cursor: { id: opts.cursor }, take, skip });

  const hasNextPage = entities.length > opts.take;

  let cursor = undefined;

  if (hasNextPage) {
    // remove extra entity we fetched
    entities.pop();
    cursor = entities[entities.length - 1].id;
  }

  return {
    pageInfo: {
      hasNextPage,
      cursor
    },
    entities
  };
}
