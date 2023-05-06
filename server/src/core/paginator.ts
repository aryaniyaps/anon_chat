interface PageInfo<T> {
  hasNextPage: boolean;
  cursor?: T;
}

export interface Paginated<T, M> {
  pageInfo: PageInfo<T>;
  data: M[];
}

export async function paginate<T, M>(data: {
  data: M[];
}): Promise<Paginated<T, M>> {
  return {
    pageInfo: {
      hasNextPage: true,
      cursor: undefined
    },
    data: []
  };
}
