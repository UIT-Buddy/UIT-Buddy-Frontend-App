import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_posts_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_state.dart';

class YourPostsBloc extends Bloc<YourPostsEvent, YourPostsState> {
  YourPostsBloc({required GetPostsUsecase getPostsUsecase})
      : _getPostsUsecase = getPostsUsecase,
        super(const YourPostsState()) {
    on<YourPostsLoaded>(_onLoaded);
    on<YourPostsSearchChanged>(_onSearchChanged);
    on<YourPostsPostDeleted>(_onPostDeleted);
  }

  final GetPostsUsecase _getPostsUsecase;

  Future<void> _onLoaded(
    YourPostsLoaded event,
    Emitter<YourPostsState> emit,
  ) async {
    emit(state.copyWith(status: YourPostsStatus.loading));
    final result = await _getPostsUsecase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: YourPostsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (posts) => emit(
        state.copyWith(
          status: YourPostsStatus.loaded,
          posts: posts,
          filtered: posts,
          searchQuery: '',
        ),
      ),
    );
  }

  void _onSearchChanged(
    YourPostsSearchChanged event,
    Emitter<YourPostsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.posts
        : state.posts
            .where((p) => p.content.toLowerCase().contains(query))
            .toList();
    emit(state.copyWith(searchQuery: event.query, filtered: filtered));
  }

  void _onPostDeleted(
    YourPostsPostDeleted event,
    Emitter<YourPostsState> emit,
  ) {
    final updatedPosts = state.posts.where((p) => p.id != event.postId).toList();
    final updatedFiltered =
        state.filtered.where((p) => p.id != event.postId).toList();
    emit(state.copyWith(posts: updatedPosts, filtered: updatedFiltered));
  }
}
