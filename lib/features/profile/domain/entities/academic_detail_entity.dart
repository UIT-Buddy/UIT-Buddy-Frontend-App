import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class AcademicDetailEntity extends Equatable {
  final int attemptedCredits;
  final int accumulatedCredits;
  final double attemptedGpaScale10;
  final double attemptedGpaScale4;
  final double accumulatedGpaScale10;
  final double accumulatedGpaScale4;
  final int accumulatedGeneralCredits;
  final int accumulatedFoundationCredits;
  final int accumulatedMajorCredits;
  final int accumulatedGraduationCredits;
  final int accumulatedElectiveCredits;
  final int accumulatedPoliticalCredits;
  final double majorProgress;

  const AcademicDetailEntity({
    required this.attemptedCredits,
    required this.accumulatedCredits,
    required this.attemptedGpaScale10,
    required this.attemptedGpaScale4,
    required this.accumulatedGpaScale10,
    required this.accumulatedGpaScale4,
    required this.accumulatedGeneralCredits,
    required this.accumulatedFoundationCredits,
    required this.accumulatedMajorCredits,
    required this.accumulatedGraduationCredits,
    required this.accumulatedElectiveCredits,
    required this.accumulatedPoliticalCredits,
    required this.majorProgress,
  });

  @override
  List<Object?> get props => [
    attemptedCredits,
    accumulatedCredits,
    attemptedGpaScale10,
    attemptedGpaScale4,
    accumulatedGpaScale10,
    accumulatedGpaScale4,
    accumulatedGeneralCredits,
    accumulatedFoundationCredits,
    accumulatedMajorCredits,
    accumulatedGraduationCredits,
    accumulatedElectiveCredits,
    accumulatedPoliticalCredits,
    majorProgress,
  ];
}
