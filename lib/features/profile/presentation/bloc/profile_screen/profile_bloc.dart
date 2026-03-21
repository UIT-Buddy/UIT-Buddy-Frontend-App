import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/sign_out_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfileUsecase getProfileUsecase,
    required SignOutUsecase signOutUsecase,
  }) : _getProfileUsecase = getProfileUsecase,
       _signOutUsecase = signOutUsecase,
       super(const ProfileState()) {
    on<ProfileStarted>(_onProfileStarted);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final GetProfileUsecase _getProfileUsecase;
  final SignOutUsecase _signOutUsecase;

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getProfileUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (profileInfo) => emit(
        state.copyWith(status: ProfileStatus.loaded, profileInfo: profileInfo),
      ),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.signingOut));

    final result = await _signOutUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProfileStatus.signedOut)),
    );
  }
}
