import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required GetProfileUsecase getProfileUsecase})
    : _getProfileUsecase = getProfileUsecase,
      super(const ProfileState()) {
    on<ProfileStarted>(_onProfileStarted);
  }

  final GetProfileUsecase _getProfileUsecase;

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getProfileUsecase(
      const GetProfileParams(email: 'current_user'),
    );

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
}
