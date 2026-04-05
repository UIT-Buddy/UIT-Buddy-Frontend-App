import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_courses_mode_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/sync_assignments_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/sync_course_assignments_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/upload_schedule_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_state.dart';

class CoursesModeBloc extends Bloc<CoursesModeEvent, CoursesModeState> {
  CoursesModeBloc({
    required GetCoursesModeUsecase getCoursesModeUsecase,
    required UploadScheduleUsecase uploadScheduleUsecase,
    required SyncAssignmentsUsecase syncAssignmentsUsecase,
    required SyncCourseAssignmentsUsecase syncCourseAssignmentsUsecase,
  }) : _getCoursesModeUsecase = getCoursesModeUsecase,
       _uploadScheduleUsecase = uploadScheduleUsecase,
       _syncAssignmentsUsecase = syncAssignmentsUsecase,
       _syncCourseAssignmentsUsecase = syncCourseAssignmentsUsecase,
       super(_buildInitialState()) {
    on<CoursesModeStarted>(_onStarted);
    on<CoursesModePreviousSemester>(_onPreviousSemester);
    on<CoursesModeNextSemester>(_onNextSemester);
    on<CoursesModeUploadScheduleRequested>(_onUploadScheduleRequested);
    on<CoursesModeSyncAssignmentsRequested>(_onSyncAssignmentsRequested);
    on<CoursesModeSyncCourseAssignmentsRequested>(
      _onSyncCourseAssignmentsRequested,
    );
  }

  final GetCoursesModeUsecase _getCoursesModeUsecase;
  final UploadScheduleUsecase _uploadScheduleUsecase;
  final SyncAssignmentsUsecase _syncAssignmentsUsecase;
  final SyncCourseAssignmentsUsecase _syncCourseAssignmentsUsecase;

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

  Future<void> _onUploadScheduleRequested(
    CoursesModeUploadScheduleRequested event,
    Emitter<CoursesModeState> emit,
  ) async {
    emit(
      state.copyWith(
        uploadStatus: UploadScheduleStatus.loading,
        uploadErrorMessage: null,
        // Reset sync state so stale deadlines from previous sync are cleared
        syncAssignmentsStatus: SyncAssignmentsStatus.idle,
        syncAssignmentsErrorMessage: null,
      ),
    );

    final result = await _uploadScheduleUsecase(
      UploadScheduleParams(filePath: event.filePath, fileName: event.fileName),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          uploadStatus: UploadScheduleStatus.failure,
          uploadErrorMessage: failure.message,
        ),
      ),
      (courses) async {
        emit(
          state.copyWith(
            uploadStatus: UploadScheduleStatus.success,
            status: CoursesModeStatus.loaded,
            // Show courses immediately while we sync deadlines in background
            courses: courses,
          ),
        );
        // Now sync deadlines from Moodle — this is the slow part, done after upload
        await _syncAssignments(emit);
      },
    );

    emit(state.copyWith(uploadStatus: UploadScheduleStatus.idle));
  }

  Future<void> _onSyncAssignmentsRequested(
    CoursesModeSyncAssignmentsRequested event,
    Emitter<CoursesModeState> emit,
  ) async {
    await _syncAssignments(emit, month: event.month, year: event.year);
  }

  Future<void> _syncAssignments(
    Emitter<CoursesModeState> emit, {
    int? month,
    int? year,
  }) async {
    emit(state.copyWith(syncAssignmentsStatus: SyncAssignmentsStatus.syncing));

    final result = await _syncAssignmentsUsecase(
      SyncAssignmentsParams(month: month, year: year),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          syncAssignmentsStatus: SyncAssignmentsStatus.failure,
          syncAssignmentsErrorMessage: failure.message,
        ),
      ),
      (courses) => emit(
        state.copyWith(
          syncAssignmentsStatus: SyncAssignmentsStatus.synced,
          courses: courses,
        ),
      ),
    );
  }

  Future<void> _onSyncCourseAssignmentsRequested(
    CoursesModeSyncCourseAssignmentsRequested event,
    Emitter<CoursesModeState> emit,
  ) async {
    // Mark this course as loading (replaces any previous loading state)
    emit(state.copyWith(loadingCourseClassId: event.classId));

    final result = await _syncCourseAssignmentsUsecase(
      SyncCourseAssignmentsParams(classId: event.classId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          // Clear loading, store error
          loadingCourseClassId: null,
          courseDeadlines: {
            ...state.courseDeadlines,
            event.classId: [], // empty = failed/no deadlines
          },
        ),
      ),
      (content) => emit(
        state.copyWith(
          // Clear loading, cache deadlines
          loadingCourseClassId: null,
          courseDeadlines: {
            ...state.courseDeadlines,
            event.classId: content.exercises,
          },
        ),
      ),
    );
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
