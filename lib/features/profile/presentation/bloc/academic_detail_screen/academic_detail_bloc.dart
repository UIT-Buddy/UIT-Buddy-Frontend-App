import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_academic_detail_usecase.dart';

abstract class AcademicDetailEvent extends Equatable {
  const AcademicDetailEvent();
  @override
  List<Object?> get props => [];
}

class AcademicDetailLoaded extends AcademicDetailEvent {
  const AcademicDetailLoaded();
}

enum AcademicDetailStatus { initial, loading, loaded, error }

class AcademicDetailState extends Equatable {
  const AcademicDetailState({
    this.status = AcademicDetailStatus.initial,
    this.detail,
    this.errorMessage,
  });

  final AcademicDetailStatus status;
  final AcademicDetailEntity? detail;
  final String? errorMessage;

  AcademicDetailState copyWith({
    AcademicDetailStatus? status,
    AcademicDetailEntity? detail,
    String? errorMessage,
  }) {
    return AcademicDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, detail, errorMessage];
}

class AcademicDetailBloc extends Bloc<AcademicDetailEvent, AcademicDetailState> {
  AcademicDetailBloc({required GetAcademicDetailsUsecase getAcademicDetailsUsecase})
      : _getAcademicDetailsUsecase = getAcademicDetailsUsecase,
        super(const AcademicDetailState()) {
    on<AcademicDetailLoaded>(_onLoaded);
  }

  final GetAcademicDetailsUsecase _getAcademicDetailsUsecase;

  Future<void> _onLoaded(AcademicDetailLoaded event, Emitter<AcademicDetailState> emit) async {
    emit(state.copyWith(status: AcademicDetailStatus.loading));
    final result = await _getAcademicDetailsUsecase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: AcademicDetailStatus.error, errorMessage: failure.message)),
      (detail) => emit(state.copyWith(status: AcademicDetailStatus.loaded, detail: detail)),
    );
  }
}
