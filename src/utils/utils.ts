import { MAX_LIMIT_ON_PAGE } from 'src/global/constant.global';

export const normalizePaginationParams = ({
  limit,
  page,
}: {
  limit?: number;
  page?: number;
}): {
  limit: number;
  page: number;
} => {
  limit = limit || 10;
  page = page || 1;
  limit = limit > MAX_LIMIT_ON_PAGE ? MAX_LIMIT_ON_PAGE : limit;
  return {
    limit,
    page,
  };
};
