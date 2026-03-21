import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

enum EditPostStatus { initial, loading, success, error }

class EditPostState extends Equatable {
  const EditPostState({
    this.status = EditPostStatus.initial,
    this.errorMessage,
    this.updatedPost,
  });

  final EditPostStatus status;
  final String? errorMessage;
  final PostEntity? updatedPost;

  bool get isLoading => status == EditPostStatus.loading;

  EditPostState copyWith({
    EditPostStatus? status,
    String? errorMessage,
    PostEntity? updatedPost,
  }) {
    return EditPostState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedPost: updatedPost ?? this.updatedPost,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, updatedPost];
}
