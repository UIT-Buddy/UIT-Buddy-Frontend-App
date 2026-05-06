/// Shared cursor/offset-based pagination helpers for social datasource impls.
mixin NotificationPagingMixin {
  String? extractNextCursor(Map<String, dynamic> body) {
    // API response has paging nested inside data: data: { ..., paging: {...} }
    final paging = body['paging'] as Map<String, dynamic>?;
    return paging?['nextCursor'] as String?;
  }

  /// Handles both cursor-based (`hasMore`) and offset-based (`page`/`totalPages`) paging.
  bool extractHasMore(
    Map<String, dynamic> body,
    int returnedCount,
    int requestedLimit,
  ) {
    // API response has paging nested inside data: data: { ..., paging: {...} }
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
