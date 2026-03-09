import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

/// Pure in-memory filter — no I/O.
/// Filters [SearchCoursesParams.courses] by [SearchCoursesParams.query]
/// (case-insensitive). Call [GetCoursesUsecase] once to populate the list;
/// then call this on every keystroke without touching the repository.
class SearchCoursesUsecase {
  List<CourseEntity> call(SearchCoursesParams params) {
    final query = params.query.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return params.courses
        .where((c) => c.displayName.toLowerCase().contains(query))
        .toList();
  }
}

@immutable
class SearchCoursesParams extends Equatable {
  const SearchCoursesParams({required this.courses, required this.query});

  final List<CourseEntity> courses;
  final String query;

  @override
  List<Object?> get props => [courses, query];
}
