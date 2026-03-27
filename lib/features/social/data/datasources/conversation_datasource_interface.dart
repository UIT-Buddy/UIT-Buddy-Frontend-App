import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

abstract interface class ConversationDatasourceInterface {
  Future<List<ConversationEntity>> getConversations({int limit = 50});

  void reset();
}
