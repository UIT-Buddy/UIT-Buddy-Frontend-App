/// Shared cursor/offset-based pagination helpers for social datasource impls.
mixin SocialPagingMixin {
  String? extractNextCursor(Map<String, dynamic> body) {
    final paging = body['paging'] as Map<String, dynamic>?;
    final nextCursor = paging?['nextCursor'] as String?;
    if (nextCursor != null && nextCursor.isNotEmpty) return nextCursor;

    if (paging != null &&
        paging.containsKey('page') &&
        paging.containsKey('totalPages')) {
      final currentPage = (paging['page'] as num?)?.toInt() ?? 1;
      final totalPages = (paging['totalPages'] as num?)?.toInt() ?? 1;
      if (currentPage < totalPages) {
        return '${currentPage + 1}';
      }
    }

    return null;
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
