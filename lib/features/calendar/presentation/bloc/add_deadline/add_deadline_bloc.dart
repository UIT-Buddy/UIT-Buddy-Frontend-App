import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/create_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_courses_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/search_courses_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_state.dart';

class AddDeadlineBloc extends Bloc<AddDeadlineEvent, AddDeadlineState> {
  AddDeadlineBloc({
    required GetCoursesUsecase getCoursesUsecase,
    required SearchCoursesUsecase searchCoursesUsecase,
    required CreateDeadlineUsecase createDeadlineUsecase,
  }) : _getCoursesUsecase = getCoursesUsecase,
       _searchCoursesUsecase = searchCoursesUsecase,
       _createDeadlineUsecase = createDeadlineUsecase,
       super(const AddDeadlineState()) {
    on<AddDeadlineStarted>(_onStarted);
    on<AddDeadlineSearchCoursesRequested>(_onSearchCoursesRequested);
    on<AddDeadlineCreateRequested>(_onCreateRequested);
  }

  final GetCoursesUsecase _getCoursesUsecase;
  final SearchCoursesUsecase _searchCoursesUsecase;
  final CreateDeadlineUsecase _createDeadlineUsecase;

  Future<void> _onStarted(
    AddDeadlineStarted event,
    Emitter<AddDeadlineState> emit,
  ) async {
    final result = await _getCoursesUsecase(const NoParams());
    result.fold((_) {}, (courses) => emit(state.copyWith(allCourses: courses)));
  }

  /// Filters [state.allCourses] locally — no repository call.
  void _onSearchCoursesRequested(
    AddDeadlineSearchCoursesRequested event,
    Emitter<AddDeadlineState> emit,
  ) {
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    final filtered = _searchCoursesUsecase(
      SearchCoursesParams(courses: state.allCourses, query: event.query),
    );
    emit(state.copyWith(suggestions: filtered.take(5).toList()));
  }

  Future<void> _onCreateRequested(
    AddDeadlineCreateRequested event,
    Emitter<AddDeadlineState> emit,
  ) async {
    emit(state.copyWith(status: AddDeadlineStatus.loading, errorMessage: null));

    final result = await _createDeadlineUsecase(
      CreateDeadlineParams(
        name: event.name,
        courseId: event.courseId,
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
