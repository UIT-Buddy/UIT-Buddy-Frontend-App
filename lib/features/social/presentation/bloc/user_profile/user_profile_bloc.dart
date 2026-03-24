import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_user_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({required GetUserProfileUsecase getUserProfileUsecase})
    : _getUserProfileUsecase = getUserProfileUsecase,
      super(const UserProfileState()) {
    on<UserProfileStarted>(_onStarted);
  }

  final GetUserProfileUsecase _getUserProfileUsecase;

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
}
