import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_state.dart';

class DeadlineBloc extends Bloc<DeadlineEvent, DeadlineState> {
  DeadlineBloc({required GetDeadlineUsecase getDeadlineUsecase})
    : _getDeadlineUsecase = getDeadlineUsecase,
      super(const DeadlineState()) {
    on<DeadlineStarted>(_onDeadlineStarted);
    on<DeadlineEntitySelected>(_onDeadlineEntitySelected);
    on<DeadlineNextMonthSelected>(_onDeadlineNextMonthSelected);
    on<DeadlinePreviousMonthSelected>(_onDeadlinePreviousMonthSelected);
  }

  final GetDeadlineUsecase _getDeadlineUsecase;

  Future<void> _onDeadlineStarted(
    DeadlineStarted event,
    Emitter<DeadlineState> emit,
  ) async {
    emit(state.copyWith(status: DeadlineModeStatus.loading));

    // Get current date for initial load
    final now = DateTime.now();
    final result = await _getDeadlineUsecase(
      GetDeadlineParams(month: now.month, year: now.year),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (calendarDeadline) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.loaded,
            calendarDeadlineEntity: calendarDeadline,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onDeadlineEntitySelected(
    DeadlineEntitySelected event,
    Emitter<DeadlineState> emit,
  ) {
    final currentEntity = state.calendarDeadlineEntity;
    if (currentEntity == null) return;

    // Check if the clicked day exists in items
    final existingItemIndex = currentEntity.items.indexWhere(
      (item) => item.day == event.day,
    );

    final isAlreadySelected =
        existingItemIndex != -1 &&
        currentEntity.items[existingItemIndex].isSelected;

    List<CalendarDeadlineItemEntity> updatedItems;

    if (existingItemIndex != -1) {
      // Day exists in items - update it
      updatedItems = currentEntity.items.map((item) {
        if (item.day == event.day) {
          // Toggle selection: if already selected, deselect it
          return CalendarDeadlineItemEntity(
            day: item.day,
            isSelected: !isAlreadySelected,
            status: item.status,
            details: item.details,
          );
        } else {
          // Deselect all other items
          return CalendarDeadlineItemEntity(
            day: item.day,
            isSelected: false,
            status: item.status,
            details: item.details,
          );
        }
      }).toList();
    } else {
      // Day doesn't exist - create new empty item and add it
      updatedItems = currentEntity.items
          .map(
            (item) => CalendarDeadlineItemEntity(
              day: item.day,
              isSelected: false,
              status: item.status,
              details: item.details,
            ),
          )
          .toList();

      // Add the new selected day as an empty item
      updatedItems.add(
        CalendarDeadlineItemEntity(
          day: event.day,
          isSelected: true,
          status: CalendarDeadlineItemEntityStatus.empty,
          details: const [],
        ),
      );

      // Sort by day
      updatedItems.sort((a, b) => a.day.compareTo(b.day));
    }

    final updatedEntity = CalendarDeadlineEntity(
      month: currentEntity.month,
      year: currentEntity.year,
      items: updatedItems,
    );

    emit(state.copyWith(calendarDeadlineEntity: updatedEntity));
  }

  Future<void> _onDeadlineNextMonthSelected(
    DeadlineNextMonthSelected event,
    Emitter<DeadlineState> emit,
  ) async {
    final currentEntity = state.calendarDeadlineEntity;
    if (currentEntity == null) return;

    emit(state.copyWith(status: DeadlineModeStatus.loading));

    // Calculate next month and year
    int nextMonth = currentEntity.month + 1;
    int nextYear = currentEntity.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }

    final result = await _getDeadlineUsecase(
      GetDeadlineParams(month: nextMonth, year: nextYear),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (calendarDeadline) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.loaded,
            calendarDeadlineEntity: calendarDeadline,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onDeadlinePreviousMonthSelected(
    DeadlinePreviousMonthSelected event,
    Emitter<DeadlineState> emit,
  ) async {
    final currentEntity = state.calendarDeadlineEntity;
    if (currentEntity == null) return;

    emit(state.copyWith(status: DeadlineModeStatus.loading));

    // Calculate previous month and year
    int previousMonth = currentEntity.month - 1;
    int previousYear = currentEntity.year;
    if (previousMonth < 1) {
      previousMonth = 12;
      previousYear--;
    }

    final result = await _getDeadlineUsecase(
      GetDeadlineParams(month: previousMonth, year: previousYear),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (calendarDeadline) {
        emit(
          state.copyWith(
            status: DeadlineModeStatus.loaded,
            calendarDeadlineEntity: calendarDeadline,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
