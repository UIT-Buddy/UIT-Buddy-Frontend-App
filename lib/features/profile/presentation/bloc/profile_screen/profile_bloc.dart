import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/sign_out_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_state.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/reset_comet_cache_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfileUsecase getProfileUsecase,
    required SignOutUsecase signOutUsecase,
    required ResetCometCacheUsecase resetCometCacheUsecase,
  }) : _getProfileUsecase = getProfileUsecase,
       _signOutUsecase = signOutUsecase,
       _resetCometCacheUsecase = resetCometCacheUsecase,
       super(const ProfileState()) {
    on<ProfileStarted>(_onProfileStarted);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final GetProfileUsecase _getProfileUsecase;
  final SignOutUsecase _signOutUsecase;
  final ResetCometCacheUsecase _resetCometCacheUsecase;
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
    await CometChat.logout(
      onSuccess: (String sessionId) {
        debugPrint("Logout CometChat Successful: $sessionId");
      },
      onError: (CometChatException e) {
        debugPrint("Logout failed with exception: ${e.message}");
      },
    );
    await _resetCometCacheUsecase(const NoParams());
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
