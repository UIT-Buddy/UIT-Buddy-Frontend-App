import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class ChatTheme {
  static CometChatConversationsStyle get conversationsStyle =>
      CometChatConversationsStyle(
        backgroundColor: AppColor.pureWhite,
      );

  static CometChatMessageListStyle get messageListStyle =>
      CometChatMessageListStyle(
        backgroundColor: AppColor.pureWhite,
      );

  static CometChatMessageComposerStyle get messageComposerStyle =>
      CometChatMessageComposerStyle(
        backgroundColor: AppColor.pureWhite,
      );

  static CometChatUsersStyle get usersStyle => CometChatUsersStyle(
    backgroundColor: AppColor.pureWhite,
  );

  static CometChatGroupsStyle get groupsStyle => CometChatGroupsStyle(
    backgroundColor: AppColor.pureWhite,
  );
}
