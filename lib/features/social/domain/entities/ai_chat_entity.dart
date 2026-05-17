import 'package:equatable/equatable.dart';

class AIChatEntity extends Equatable {
  final String id;
  final String message;
  final bool isUserMessage;
  final DateTime timestamp;

  const AIChatEntity({
    required this.id,
    required this.message,
    required this.isUserMessage,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, message, isUserMessage, timestamp];
}
