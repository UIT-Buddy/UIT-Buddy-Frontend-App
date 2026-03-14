import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_your_info_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/update_your_info_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_state.dart';

class YourInfoBloc extends Bloc<YourInfoEvent, YourInfoState> {
  YourInfoBloc({
    required GetYourInfoUsecase getYourInfoUsecase,
    required UpdateYourInfoUsecase updateYourInfoUsecase,
  })  : _getYourInfoUsecase = getYourInfoUsecase,
        _updateYourInfoUsecase = updateYourInfoUsecase,
        super(const YourInfoState()) {
    on<YourInfoLoaded>(_onLoaded);
    on<YourInfoUpdated>(_onUpdated);
  }

  final GetYourInfoUsecase _getYourInfoUsecase;
  final UpdateYourInfoUsecase _updateYourInfoUsecase;

  Future<void> _onLoaded(
    YourInfoLoaded event,
    Emitter<YourInfoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getYourInfoUsecase(null);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (info) => emit(state.copyWith(isLoading: false, yourInfo: info)),
    );
  }

  Future<void> _onUpdated(
    YourInfoUpdated event,
    Emitter<YourInfoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _updateYourInfoUsecase(event.info);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (info) => emit(state.copyWith(isLoading: false, yourInfo: info)),
    );
  }
}