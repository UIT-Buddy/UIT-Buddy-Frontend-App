/// Shared cursor/offset-based pagination helpers for social datasource impls.
mixin YourPostsPagingMixin {
  String? extractNextCursor(Map<String, dynamic> body) {
    final paging = body['paging'] as Map<String, dynamic>?;
    return paging?['nextCursor'] as String?;
  }

  /// Handles both cursor-based (`hasMore`) and offset-based (`page`/`totalPages`) paging.
  bool extractHasMore(
    Map<String, dynamic> body,
    int returnedCount,
    int requestedLimit,
  ) {
    final paging = body['paging'] as Map<String, dynamic>?;
    if (paging == null) return false;

    if (paging.containsKey('hasMore')) {
      return (paging['hasMore'] as bool?) ?? false;
    }
    if (paging.containsKey('page') && paging.containsKey('totalPages')) {
      return (paging['page'] as int) < (paging['totalPages'] as int);
    }
    return returnedCount == requestedLimit;
  }
}
