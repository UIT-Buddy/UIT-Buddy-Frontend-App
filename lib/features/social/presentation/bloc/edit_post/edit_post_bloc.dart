import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/update_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_state.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  EditPostBloc({required UpdatePostUsecase updatePostUsecase})
    : _updatePostUsecase = updatePostUsecase,
      super(const EditPostState()) {
    on<EditPostSubmitted>(_onSubmitted);
  }

  final UpdatePostUsecase _updatePostUsecase;

  Future<void> _onSubmitted(
    EditPostSubmitted event,
    Emitter<EditPostState> emit,
  ) async {
    emit(state.copyWith(status: EditPostStatus.loading));

    final result = await _updatePostUsecase(
      UpdatePostParams(
        postId: event.originalPost.id,
        title: event.title,
        content: event.content,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditPostStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: EditPostStatus.success,
          updatedPost: event.originalPost.copyWith(
            title: event.title,
            contentSnippet: event.content ?? '',
          ),
        ),
      ),
    );
  }
}
