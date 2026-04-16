import 'package:equatable/equatable.dart';

class PageParams extends Equatable {
  final String? page;
  final int limit;
  final String? sortType;
  final String? sortBy;
  final String? keyword;

  const PageParams({
    this.page,
    this.limit = 10,
    this.sortType,
    this.sortBy,
    this.keyword,
  });

  @override
  List<Object?> get props => [page, limit, sortType, sortBy, keyword];
}
