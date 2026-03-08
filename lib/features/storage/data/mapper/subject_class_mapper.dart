import 'package:uit_buddy_mobile/features/storage/data/models/subject_class_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

extension SubjectClassMapper on SubjectClassModel {
  SubjectClassEntity toEntity() => SubjectClassEntity(
        classCode: classCode,
        courseCode: courseCode,
        course: course,
      );
}
