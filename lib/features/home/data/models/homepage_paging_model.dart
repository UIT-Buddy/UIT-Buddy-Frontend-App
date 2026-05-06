import 'package:freezed_annotation/freezed_annotation.dart';

part 'homepage_paging_model.freezed.dart';
part 'homepage_paging_model.g.dart';

@freezed
abstract class HomepagePagingModel with _$HomepagePagingModel {
  const factory HomepagePagingModel({
    required int currentPage,
    required int totalPages,
    required int totalElements,
  }) = _HomepagePagingModel;

  factory HomepagePagingModel.fromJson(Map<String, dynamic> json) =>
      _$HomepagePagingModelFromJson(json);
}
