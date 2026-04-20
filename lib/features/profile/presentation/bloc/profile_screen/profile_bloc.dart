import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/sign_out_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/upload_profile_cover_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfileUsecase getProfileUsecase,
    required SignOutUsecase signOutUsecase,
    required UploadProfileCoverUsecase uploadProfileCoverUsecase,
  }) : _getProfileUsecase = getProfileUsecase,
       _signOutUsecase = signOutUsecase,
       _uploadProfileCoverUsecase = uploadProfileCoverUsecase,
       super(const ProfileState()) {
    on<ProfileStarted>(_onProfileStarted);
    on<ProfileCoverUploadRequested>(_onProfileCoverUploadRequested);
    on<ProfileFeedbackCleared>(_onProfileFeedbackCleared);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final GetProfileUsecase _getProfileUsecase;
  final SignOutUsecase _signOutUsecase;
  final UploadProfileCoverUsecase _uploadProfileCoverUsecase;

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        errorMessage: () => null,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final result = await _getProfileUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: () => failure.message,
        ),
      ),
      (profileInfo) => emit(
        state.copyWith(status: ProfileStatus.loaded, profileInfo: profileInfo),
      ),
    );
  }

  Future<void> _onProfileCoverUploadRequested(
    ProfileCoverUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isUploadingCover || state.status == ProfileStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        isUploadingCover: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final uploadResult = await _uploadProfileCoverUsecase(
      UploadProfileCoverParams(
        fileBytes: event.fileBytes,
        fileName: event.fileName,
      ),
    );

    await uploadResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isUploadingCover: false,
            actionErrorMessage: () => failure.message,
          ),
        );
      },
      (_) async {
        final refreshResult = await _getProfileUsecase(const NoParams());

        refreshResult.fold(
          (failure) => emit(
            state.copyWith(
              isUploadingCover: false,
              actionErrorMessage: () =>
                  'Cover uploaded, but failed to refresh profile: ${failure.message}',
            ),
          ),
          (profileInfo) => emit(
            state.copyWith(
              status: ProfileStatus.loaded,
              isUploadingCover: false,
              profileInfo: profileInfo,
              actionSuccessMessage: () => 'Cover photo updated successfully.',
            ),
          ),
        );
      },
    );
  }

  void _onProfileFeedbackCleared(
    ProfileFeedbackCleared event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
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
          errorMessage: () => failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProfileStatus.signedOut)),
    );
  }
}
