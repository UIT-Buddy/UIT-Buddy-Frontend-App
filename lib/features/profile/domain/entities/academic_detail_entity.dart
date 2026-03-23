import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class AcademicDetailEntity extends Equatable {
  final int attemptedCredits;
  final int accumulatedCredits;
  final int generalCredits;
  final int foundationCredits;
  final int majorCredits;
  final int graduationCredits;
  final double majorProgress;
  final double currentGpa;
  final double targetGpa;

  const AcademicDetailEntity({
    required this.attemptedCredits,
    required this.accumulatedCredits,
    required this.generalCredits,
    required this.foundationCredits,
    required this.majorCredits,
    required this.graduationCredits,
    required this.majorProgress,
    required this.currentGpa,
    required this.targetGpa,
  });

  @override
  List<Object?> get props => [
    attemptedCredits,
    accumulatedCredits,
    generalCredits,
    foundationCredits,
    majorCredits,
    graduationCredits,
    majorProgress,
    currentGpa,
    targetGpa,
  ];
}
