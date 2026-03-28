import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comet_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_friend_users_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_state.dart';

EventTransformer<UserSearchQueryChanged> _debounce(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc({required GetFriendUsersUsecase getFriendUsersUsecase})
    : _getFriendUsersUsecase = getFriendUsersUsecase,
      super(const UserSearchState()) {
    on<UserSearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
  }

  final GetFriendUsersUsecase _getFriendUsersUsecase;
  final List<CometUserEntity> _allUsers = [];
  Future<Either<Failure, List<CometUserEntity>>>? _friendUsersRequest;
  bool _hasLoadedFriends = false;

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

    if (!_hasLoadedFriends) {
      emit(
        state.copyWith(
          status: UserSearchStatus.loading,
          query: query,
          errorMessage: null,
        ),
      );

      final result = await _loadFriendUsers();

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: UserSearchStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            status: UserSearchStatus.loaded,
            query: query,
            users: _applyLocalFilter(query),
            errorMessage: null,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: UserSearchStatus.loaded,
        query: query,
        users: _applyLocalFilter(query),
        errorMessage: null,
      ),
    );
  }

  Future<Either<Failure, List<CometUserEntity>>> _loadFriendUsers() {
    if (_hasLoadedFriends) {
      return Future.value(Right(_allUsers));
    }

    return _friendUsersRequest ??= _getFriendUsersUsecase(const NoParams())
        .then((result) {
          result.fold((_) => _friendUsersRequest = null, (users) {
            _allUsers
              ..clear()
              ..addAll(users);
            _hasLoadedFriends = true;
          });
          return result;
        });
  }

  List<CometUserEntity> _applyLocalFilter(String query) {
    final normalizedQuery = _normalizeForSearch(query);
    if (normalizedQuery.isEmpty) return const [];

    return _allUsers.where((user) {
      final normalizedName = _normalizeForSearch(user.name);
      final normalizedUid = _normalizeForSearch(user.uid);
      return normalizedName.contains(normalizedQuery) ||
          normalizedUid.contains(normalizedQuery);
    }).toList();
  }

  String _normalizeForSearch(String value) {
    final lowercased = value.trim().toLowerCase();
    if (lowercased.isEmpty) return '';

    const replacements = <String, String>{
      'à': 'a',
      'á': 'a',
      'ạ': 'a',
      'ả': 'a',
      'ã': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ậ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ặ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'è': 'e',
      'é': 'e',
      'ẹ': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ệ': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ì': 'i',
      'í': 'i',
      'ị': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ò': 'o',
      'ó': 'o',
      'ọ': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ộ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ợ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ụ': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ự': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỵ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'đ': 'd',
    };

    final buffer = StringBuffer();
    for (final char in lowercased.split('')) {
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString();
  }
}
