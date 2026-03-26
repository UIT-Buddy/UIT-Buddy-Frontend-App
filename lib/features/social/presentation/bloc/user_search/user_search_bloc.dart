import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/search_users_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_state.dart';

EventTransformer<UserSearchQueryChanged> _debounce(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc({required SearchUsersUsecase searchUsersUsecase})
    : _searchUsersUsecase = searchUsersUsecase,
      super(const UserSearchState()) {
    on<UserSearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
  }

  final SearchUsersUsecase _searchUsersUsecase;

  Future<void> _onQueryChanged(
    UserSearchQueryChanged event,
    Emitter<UserSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(status: UserSearchStatus.initial, users: [], query: ''),
      );
      return;
    }

    emit(state.copyWith(status: UserSearchStatus.loading, query: query));

    final result = await _searchUsersUsecase(SearchUsersParams(keyword: query));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserSearchStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (users) =>
          emit(state.copyWith(status: UserSearchStatus.loaded, users: users)),
    );
  }
}
