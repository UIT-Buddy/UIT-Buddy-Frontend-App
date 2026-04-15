import 'package:equatable/equatable.dart';

class StorageCursorParams extends Equatable {
  const StorageCursorParams({this.cursor, this.limit = 10});

  final String? cursor;
  final int limit;

  @override
  List<Object?> get props => [cursor, limit];
}
