import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_next_class_entity.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        userName: 'Đình Minh',
        classCountToday: 1,
        nextClass: () => const HomeNextClassEntity(
          courseCode: 'SE100.Q21',
          courseName: 'Phương pháp phát triển phần mềm hướng đối tượng',
          room: 'B2.14',
          lecturer: 'TS. Lê Thanh Trọng',
          minutesUntilStart: 15,
          memberCount: 12,
        ),
        deadlines: [
          HomeDeadlineEntity(
            id: '1',
            title: 'Báo cáo cuối kì web',
            deadline: now.add(const Duration(minutes: 40)),
            courseId: 'SE347',
          ),
          HomeDeadlineEntity(
            id: '2',
            title: 'Nộp bài 123',
            deadline: now.add(const Duration(days: 2)),
            courseId: 'SE100',
          ),
          HomeDeadlineEntity(
            id: '3',
            title: 'Báo cáo cuối kì pdf',
            deadline: now.add(const Duration(days: 7)),
            courseId: 'SE347',
          ),
        ],
      ),
    );
  }
}
