import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

abstract interface class ChatDatasourceInterface {
  Future<List<MessageEntity>> getMessages({
    required String uid,
    int limit = 30,
  });

  Future<List<MessageEntity>> getGroupMessages({
    required String guid,
    int limit = 30,
  });

  void reset();

  Future<List<User>> searchCometUsers({
    required String query,
    int page = 1,
    int limit = 10,
  });
}
