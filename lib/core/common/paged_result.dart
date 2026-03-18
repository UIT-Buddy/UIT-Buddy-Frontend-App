class PagedResult<T> {
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;

  const PagedResult({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
  });
}
