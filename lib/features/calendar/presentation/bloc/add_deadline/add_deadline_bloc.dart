import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/create_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_studying_class_codes_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_state.dart';

class AddDeadlineBloc extends Bloc<AddDeadlineEvent, AddDeadlineState> {
  AddDeadlineBloc({
    required GetStudyingClassCodesUsecase getStudyingClassCodesUsecase,
    required CreateDeadlineUsecase createDeadlineUsecase,
  }) : _getStudyingClassCodesUsecase = getStudyingClassCodesUsecase,
       _createDeadlineUsecase = createDeadlineUsecase,
       super(const AddDeadlineState()) {
    on<AddDeadlineStarted>(_onStarted);
    on<AddDeadlineSearchClassCodesRequested>(_onSearchClassCodesRequested);
    on<AddDeadlineCreateRequested>(_onCreateRequested);
  }

  final GetStudyingClassCodesUsecase _getStudyingClassCodesUsecase;
  final CreateDeadlineUsecase _createDeadlineUsecase;

  Future<void> _onStarted(
    AddDeadlineStarted event,
    Emitter<AddDeadlineState> emit,
  ) async {
    emit(state.copyWith(status: AddDeadlineStatus.loading, errorMessage: null));

    final result = await _getStudyingClassCodesUsecase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddDeadlineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (classCodes) => emit(
        state.copyWith(
          status: AddDeadlineStatus.initial,
          allClassCodes: classCodes,
        ),
      ),
    );
  }

  void _onSearchClassCodesRequested(
    AddDeadlineSearchClassCodesRequested event,
    Emitter<AddDeadlineState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    final filtered = state.allClassCodes
        .where((code) => code.toLowerCase().contains(query))
        .take(5)
        .toList();
    emit(state.copyWith(suggestions: filtered));
  }

  Future<void> _onCreateRequested(
    AddDeadlineCreateRequested event,
    Emitter<AddDeadlineState> emit,
  ) async {
    emit(state.copyWith(status: AddDeadlineStatus.loading, errorMessage: null));

    final result = await _createDeadlineUsecase(
      CreateDeadlineParams(
        name: event.name,
        classCode: event.classCode,
        deadline: event.deadline,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddDeadlineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AddDeadlineStatus.created)),
    );
  }
}
