import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/usecases/get_deadline_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/usecases/update_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_event.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_state.dart';

class DeadlineBloc extends Bloc<DeadlineEvent, DeadlineState> {
  final GetDeadlineDetailUsecase getDeadlineDetailUsecase;
  final UpdateDeadlineUsecase updateDeadlineUsecase;

  DeadlineBloc({
    required this.getDeadlineDetailUsecase,
    required this.updateDeadlineUsecase,
  }) : super(const DeadlineState()) {
    on<FetchDeadlineRequested>(_onFetchDeadlineRequested);
    on<UpdateDeadlineRequested>(_onUpdateDeadlineRequested);
  }

  Future<void> _onFetchDeadlineRequested(
    FetchDeadlineRequested event,
    Emitter<DeadlineState> emit,
  ) async {
    emit(state.copyWith(status: DeadlineStateStatus.loading));

    final result = await getDeadlineDetailUsecase(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DeadlineStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (deadlineDetail) => emit(
        state.copyWith(
          status: DeadlineStateStatus.loaded,
          deadlineDetail: deadlineDetail,
        ),
      ),
    );
  }

  Future<void> _onUpdateDeadlineRequested(
    UpdateDeadlineRequested event,
    Emitter<DeadlineState> emit,
  ) async {
    emit(state.copyWith(status: DeadlineStateStatus.loading));

    final result = await updateDeadlineUsecase(
      UpdateDeadlineParams(
        studentTaskId: event.studentTaskId,
        exerciseName: event.exerciseName,
        dueDate: event.dueDate,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DeadlineStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        add(FetchDeadlineRequested(event.studentTaskId));
      },
    );
  }
}
