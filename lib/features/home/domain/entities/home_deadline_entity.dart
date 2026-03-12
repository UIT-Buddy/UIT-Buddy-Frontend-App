import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HomeDeadlineUrgency { urgent, warning, normal }

@immutable
class HomeDeadlineEntity extends Equatable {
  final String id;
  final String title;
  final DateTime deadline;
  final String courseId;

  const HomeDeadlineEntity({
    required this.id,
    required this.title,
    required this.deadline,
    required this.courseId,
  });

  HomeDeadlineUrgency get urgency {
    final diff = deadline.difference(DateTime.now());
    if (diff.inHours < 1) return HomeDeadlineUrgency.urgent;
    if (diff.inDays < 3) return HomeDeadlineUrgency.warning;
    return HomeDeadlineUrgency.normal;
  }

  String get timeLeftLabel {
    final diff = deadline.difference(DateTime.now());
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins left';
    if (diff.inHours < 24) return '${diff.inHours} hrs left';
    return '${diff.inDays} days left';
  }

  @override
  List<Object?> get props => [id, title, deadline, courseId];
}
