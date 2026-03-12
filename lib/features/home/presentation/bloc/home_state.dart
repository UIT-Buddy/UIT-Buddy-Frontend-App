import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_next_class_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.userName = '',
    this.classCountToday = 0,
    this.nextClass,
    this.deadlines = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final String userName;
  final int classCountToday;
  final HomeNextClassEntity? nextClass;
  final List<HomeDeadlineEntity> deadlines;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    String? userName,
    int? classCountToday,
    HomeNextClassEntity? Function()? nextClass,
    List<HomeDeadlineEntity>? deadlines,
    String? Function()? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      classCountToday: classCountToday ?? this.classCountToday,
      nextClass: nextClass != null ? nextClass() : this.nextClass,
      deadlines: deadlines ?? this.deadlines,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    classCountToday,
    nextClass,
    deadlines,
    errorMessage,
  ];
}
