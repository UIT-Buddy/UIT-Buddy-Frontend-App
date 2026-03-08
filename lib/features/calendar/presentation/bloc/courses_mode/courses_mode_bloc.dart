import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_courses_mode_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_state.dart';

class CoursesModeBloc extends Bloc<CoursesModeEvent, CoursesModeState> {
  CoursesModeBloc({required GetCoursesModeUsecase getCoursesModeUsecase})
    : _getCoursesModeUsecase = getCoursesModeUsecase,
      super(_buildInitialState()) {
    on<CoursesModeStarted>(_onStarted);
    on<CoursesModePreviousSemester>(_onPreviousSemester);
    on<CoursesModeNextSemester>(_onNextSemester);
  }

  final GetCoursesModeUsecase _getCoursesModeUsecase;

  static CoursesModeState _buildInitialState() {
    final now = DateTime.now();
    // Semester 1: Sep–Jan, Semester 2: Feb–Jun, treat Jul–Aug as upcoming Sem 1
    final semester = now.month >= 9 ? 1 : 2;
    return CoursesModeState(semester: semester, year: now.year);
  }

  Future<void> _onStarted(
    CoursesModeStarted event,
    Emitter<CoursesModeState> emit,
  ) async {
    await _fetchCourses(emit);
  }

  Future<void> _onPreviousSemester(
    CoursesModePreviousSemester event,
    Emitter<CoursesModeState> emit,
  ) async {
    final (semester, year) = _previousSemester(state.semester, state.year);
    emit(state.copyWith(semester: semester, year: year));
    await _fetchCourses(emit);
  }

  Future<void> _onNextSemester(
    CoursesModeNextSemester event,
    Emitter<CoursesModeState> emit,
  ) async {
    final (semester, year) = _nextSemester(state.semester, state.year);
    emit(state.copyWith(semester: semester, year: year));
    await _fetchCourses(emit);
  }

  Future<void> _fetchCourses(Emitter<CoursesModeState> emit) async {
    emit(state.copyWith(status: CoursesModeStatus.loading));
    final result = await _getCoursesModeUsecase(
      GetCoursesModeParams(semester: state.semester, year: state.year),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CoursesModeStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (courses) => emit(
        state.copyWith(
          status: CoursesModeStatus.loaded,
          courses: courses,
          errorMessage: null,
        ),
      ),
    );
  }

  static (int semester, int year) _previousSemester(int semester, int year) =>
      semester == 1 ? (2, year - 1) : (semester - 1, year);

  static (int semester, int year) _nextSemester(int semester, int year) =>
      semester == 2 ? (1, year + 1) : (semester + 1, year);
}
