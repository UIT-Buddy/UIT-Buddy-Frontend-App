import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_user_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/respond_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/unfriend_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required GetUserProfileUsecase getUserProfileUsecase,
    required ToggleFriendRequestUsecase toggleFriendRequestUsecase,
    required RespondFriendRequestUsecase respondFriendRequestUsecase,
    required UnfriendUsecase unfriendUsecase,
  }) : _getUserProfileUsecase = getUserProfileUsecase,
       _toggleFriendRequestUsecase = toggleFriendRequestUsecase,
       _respondFriendRequestUsecase = respondFriendRequestUsecase,
       _unfriendUsecase = unfriendUsecase,
       super(const UserProfileState()) {
    on<UserProfileStarted>(_onStarted);
    on<UserProfileFriendActionSubmitted>(_onFriendActionSubmitted);
    on<UserProfileFeedbackCleared>(_onFeedbackCleared);
  }

  final GetUserProfileUsecase _getUserProfileUsecase;
  final ToggleFriendRequestUsecase _toggleFriendRequestUsecase;
  final RespondFriendRequestUsecase _respondFriendRequestUsecase;
  final UnfriendUsecase _unfriendUsecase;

  Future<void> _onStarted(
    UserProfileStarted event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading, errorMessage: null));

    final result = await _getUserProfileUsecase(
      GetUserProfileParams(mssv: event.mssv),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: UserProfileStatus.loaded, user: user)),
    );
  }

  Future<void> _onFriendActionSubmitted(
    UserProfileFriendActionSubmitted event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = state.user;
    if (user == null || state.isFriendActionLoading) return;

    emit(
      state.copyWith(
        isFriendActionLoading: true,
        activeFriendAction: event.action,
        actionErrorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await switch (event.action) {
      UserProfileFriendAction.sendRequest ||
      UserProfileFriendAction.cancelRequest => _toggleFriendRequestUsecase(
        ToggleFriendRequestParams(receiverMssv: user.mssv),
      ),
      UserProfileFriendAction.acceptRequest => _respondFriendRequestUsecase(
        RespondFriendRequestParams(
          senderMssv: user.mssv,
          action: FriendRequestResponseAction.accept,
        ),
      ),
      UserProfileFriendAction.rejectRequest => _respondFriendRequestUsecase(
        RespondFriendRequestParams(
          senderMssv: user.mssv,
          action: FriendRequestResponseAction.reject,
        ),
      ),
      UserProfileFriendAction.unfriend => _unfriendUsecase(
        UnfriendParams(friendMssv: user.mssv),
      ),
    };

    result.fold(
      (failure) => emit(
        state.copyWith(
          isFriendActionLoading: false,
          activeFriendAction: null,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          user: user.copyWith(
            friendStatus: _nextStatus(user.friendStatus, event.action),
          ),
          isFriendActionLoading: false,
          activeFriendAction: null,
          actionSuccessMessage: _successMessage(event.action),
        ),
      ),
    );
  }

  void _onFeedbackCleared(
    UserProfileFeedbackCleared event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(actionErrorMessage: null, actionSuccessMessage: null));
  }

  FriendStatus _nextStatus(
    FriendStatus currentStatus,
    UserProfileFriendAction action,
  ) {
    return switch (action) {
      UserProfileFriendAction.sendRequest => FriendStatus.pending,
      UserProfileFriendAction.cancelRequest => FriendStatus.none,
      UserProfileFriendAction.acceptRequest => FriendStatus.friends,
      UserProfileFriendAction.rejectRequest => FriendStatus.none,
      UserProfileFriendAction.unfriend => FriendStatus.none,
    };
  }

  String _successMessage(UserProfileFriendAction action) {
    return switch (action) {
      UserProfileFriendAction.sendRequest => 'Friend request sent.',
      UserProfileFriendAction.cancelRequest => 'Friend request canceled.',
      UserProfileFriendAction.acceptRequest => 'Friend request accepted.',
      UserProfileFriendAction.rejectRequest => 'Friend request rejected.',
      UserProfileFriendAction.unfriend => 'Friend removed successfully.',
    };
  }
}
