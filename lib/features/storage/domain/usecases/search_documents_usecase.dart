import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class SearchDocumentsUsecase
    implements UseCase<List<FileEntity>, SearchDocumentsParams> {
  SearchDocumentsUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, List<FileEntity>>> call(
    SearchDocumentsParams params,
  ) async => _storageRepository.searchDocuments(
    page: params.page,
    limit: params.limit,
    sortType: params.sortType,
    sortBy: params.sortBy,
    keyword: params.keyword,
  );
}

class SearchDocumentsParams extends Equatable {
  final int? page;
  final int? limit;
  final String? sortType;
  final String? sortBy;
  final String keyword;

  const SearchDocumentsParams({
    this.page,
    this.limit,
    this.sortType,
    this.sortBy,
    required this.keyword,
  });

  @override
  List<Object?> get props => [page, limit, sortType, sortBy, keyword];
}
