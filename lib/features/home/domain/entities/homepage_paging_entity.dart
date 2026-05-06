import 'package:equatable/equatable.dart';

class HomepagePagingEntity extends Equatable {
  const HomepagePagingEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalElements,
  });

  final int currentPage;
  final int totalPages;
  final int totalElements;

  @override
  List<Object?> get props => [currentPage, totalPages, totalElements];
}
