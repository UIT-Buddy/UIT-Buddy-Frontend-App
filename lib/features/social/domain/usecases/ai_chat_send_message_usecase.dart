import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/ai_chat_repository.dart';

class AIChatSendMessageUsecase implements UseCase<String, String> {
  final AIChatRepository repository;

  AIChatSendMessageUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(String message) {
    return repository.sendMessage(message);
  }
}
