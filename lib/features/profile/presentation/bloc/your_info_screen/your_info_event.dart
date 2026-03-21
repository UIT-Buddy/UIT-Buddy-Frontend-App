import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';

abstract class YourInfoEvent extends Equatable {
  const YourInfoEvent();

  @override
  List<Object?> get props => [];
}

class YourInfoLoaded extends YourInfoEvent {
  const YourInfoLoaded();
}

class YourInfoUpdated extends YourInfoEvent {
  const YourInfoUpdated({required this.info});
  final YourInfoEntity info;

  @override
  List<Object?> get props => [info];
}
