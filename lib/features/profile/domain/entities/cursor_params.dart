import 'package:equatable/equatable.dart';

class CursorParams extends Equatable {
  final String? cursor;
  final int limit;

  const CursorParams({this.cursor, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}