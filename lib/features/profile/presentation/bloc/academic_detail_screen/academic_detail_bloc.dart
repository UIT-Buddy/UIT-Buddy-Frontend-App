import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_academic_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/import_grade_usecase.dart';

abstract class AcademicDetailEvent extends Equatable {
  const AcademicDetailEvent();
  @override
  List<Object?> get props => [];
}

class AcademicDetailLoaded extends AcademicDetailEvent {
  const AcademicDetailLoaded();
}

class AcademicDetailImportRequested extends AcademicDetailEvent {
  const AcademicDetailImportRequested({
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  @override
  List<Object?> get props => [filePath, fileName];
}

enum AcademicDetailStatus { initial, loading, loaded, error }

enum AcademicDetailImportStatus { idle, loading, success, failure }

class AcademicDetailState extends Equatable {
  const AcademicDetailState({
    this.status = AcademicDetailStatus.initial,
    this.detail,
    this.errorMessage,
    this.importStatus = AcademicDetailImportStatus.idle,
    this.importMessage,
  });

  final AcademicDetailStatus status;
  final AcademicDetailEntity? detail;
  final String? errorMessage;
  final AcademicDetailImportStatus importStatus;
  final String? importMessage;

  AcademicDetailState copyWith({
    AcademicDetailStatus? status,
    AcademicDetailEntity? detail,
    String? errorMessage,
    AcademicDetailImportStatus? importStatus,
    String? importMessage,
  }) {
    return AcademicDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage ?? this.errorMessage,
      importStatus: importStatus ?? this.importStatus,
      importMessage: importMessage ?? this.importMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detail,
    errorMessage,
    importStatus,
    importMessage,
  ];
}

class AcademicDetailBloc
    extends Bloc<AcademicDetailEvent, AcademicDetailState> {
  AcademicDetailBloc({
    required GetAcademicDetailsUsecase getAcademicDetailsUsecase,
    required ImportGradeUsecase importGradeUsecase,
  }) : _getAcademicDetailsUsecase = getAcademicDetailsUsecase,
       _importGradeUsecase = importGradeUsecase,
       super(const AcademicDetailState()) {
    on<AcademicDetailLoaded>(_onLoaded);
    on<AcademicDetailImportRequested>(_onImportRequested);
  }

  final GetAcademicDetailsUsecase _getAcademicDetailsUsecase;
  final ImportGradeUsecase _importGradeUsecase;

  Future<void> _onLoaded(
    AcademicDetailLoaded event,
    Emitter<AcademicDetailState> emit,
  ) async {
    emit(state.copyWith(status: AcademicDetailStatus.loading));
    final result = await _getAcademicDetailsUsecase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AcademicDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (detail) => emit(
        state.copyWith(status: AcademicDetailStatus.loaded, detail: detail),
      ),
    );
  }

  Future<void> _onImportRequested(
    AcademicDetailImportRequested event,
    Emitter<AcademicDetailState> emit,
  ) async {
    emit(state.copyWith(importStatus: AcademicDetailImportStatus.loading));

    final result = await _importGradeUsecase(
      ImportGradeParams(filePath: event.filePath, fileName: event.fileName),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          importStatus: AcademicDetailImportStatus.failure,
          importMessage: failure.message,
        ),
      ),
      (message) async {
        emit(
          state.copyWith(
            importStatus: AcademicDetailImportStatus.success,
            importMessage: message,
          ),
        );

        final summary = await _getAcademicDetailsUsecase(const NoParams());
        summary.fold(
          (_) {},
          (detail) => emit(
            state.copyWith(status: AcademicDetailStatus.loaded, detail: detail),
          ),
        );
      },
    );

    emit(state.copyWith(importStatus: AcademicDetailImportStatus.idle));
  }
}
