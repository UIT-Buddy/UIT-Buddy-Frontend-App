import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_semester_detail_usecase.dart';

abstract class SemesterDetailEvent extends Equatable {
  const SemesterDetailEvent();
  @override
  List<Object?> get props => [];
}

class SemesterDetailLoaded extends SemesterDetailEvent {
  const SemesterDetailLoaded();
}

enum SemesterDetailStatus { initial, loading, loaded, error }

class SemesterDetailState extends Equatable {
  const SemesterDetailState({
    this.status = SemesterDetailStatus.initial,
    this.details = const [],
    this.errorMessage,
  });

  final SemesterDetailStatus status;
  final List<SemesterDetailEntity> details;
  final String? errorMessage;

  SemesterDetailState copyWith({
    SemesterDetailStatus? status,
    List<SemesterDetailEntity>? details,
    String? errorMessage,
  }) {
    return SemesterDetailState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}

class SemesterDetailBloc extends Bloc<SemesterDetailEvent, SemesterDetailState> {
  SemesterDetailBloc({required GetSemesterDetailsUsecase getSemesterDetailsUsecase})
      : _getSemesterDetailsUsecase = getSemesterDetailsUsecase,
        super(const SemesterDetailState()) {
    on<SemesterDetailLoaded>(_onLoaded);
  }

  final GetSemesterDetailsUsecase _getSemesterDetailsUsecase;

  Future<void> _onLoaded(SemesterDetailLoaded event, Emitter<SemesterDetailState> emit) async {
    emit(state.copyWith(status: SemesterDetailStatus.loading));
    final result = await _getSemesterDetailsUsecase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: SemesterDetailStatus.error, errorMessage: failure.message)),
      (details) => emit(state.copyWith(status: SemesterDetailStatus.loaded, details: details)),
    );
  }
}
