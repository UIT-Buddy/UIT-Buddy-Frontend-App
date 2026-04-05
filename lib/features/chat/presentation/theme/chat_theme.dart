import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class ChatTheme {
  // Conversations List
  static CometChatConversationsStyle get conversationsStyle =>
      CometChatConversationsStyle(
        backgroundColor: AppColor.pureWhite,
        titleTextColor: AppColor.primaryText,
        itemTitleTextColor: AppColor.primaryText,
        itemSubtitleTextColor: AppColor.secondaryText,
        separatorColor: AppColor.dividerGrey,
        searchBackgroundColor: AppColor.veryLightGrey,
        searchIconColor: AppColor.secondaryText,
        searchPlaceHolderTextColor: AppColor.secondaryText,
        backIconColor: AppColor.primaryBlue,
        submitIconColor: AppColor.primaryBlue,
        checkboxSelectedIconColor: AppColor.primaryBlue,
        checkBoxCheckedBackgroundColor: AppColor.primaryBlue,
        messageTypeIconColor: AppColor.primaryBlue,
        checkBoxBackgroundColor: AppColor.primaryBlue,
        badgeStyle: CometChatBadgeStyle(
          textColor: AppColor.pureWhite,
          backgroundColor: AppColor.primaryBlue,
        ),
        receiptStyle: CometChatMessageReceiptStyle(
          sentIconColor: AppColor.primaryBlue,
          readIconColor: AppColor.primaryBlue,
          waitIconColor: AppColor.primaryBlue,
          deliveredIconColor: AppColor.primaryBlue,
        ),
      );

  // Message List
  static CometChatMessageListStyle get messageListStyle =>
      CometChatMessageListStyle(
        backgroundColor: AppColor.pureWhite,
        emptyStateTextColor: AppColor.secondaryText,
        emptyStateSubtitleColor: AppColor.tertiaryText,
        outgoingMessageBubbleStyle: CometChatOutgoingMessageBubbleStyle(
          backgroundColor: AppColor.primaryBlue,
          textBubbleStyle: CometChatTextBubbleStyle(
            textColor: AppColor.pureWhite,
          ),
          deletedBubbleStyle: CometChatDeletedBubbleStyle(
            backgroundColor: AppColor.dividerGrey,
            textColor: AppColor.secondaryText,
            iconColor: AppColor.secondaryText,
          ),
        ),
        incomingMessageBubbleStyle: CometChatIncomingMessageBubbleStyle(
          backgroundColor: AppColor.bubbleGrey,
          textBubbleStyle: CometChatTextBubbleStyle(
            textColor: AppColor.primaryText,
          ),
          deletedBubbleStyle: CometChatDeletedBubbleStyle(
            backgroundColor: AppColor.dividerGrey,
            textColor: AppColor.secondaryText,
            iconColor: AppColor.secondaryText,
          ),
        ),
      );

  // Message Composer (for full composer)
  static CometChatMessageComposerStyle get messageComposerStyle =>
      CometChatMessageComposerStyle(
        backgroundColor: AppColor.pureWhite,
        filledColor: AppColor.veryLightGrey,
        textColor: AppColor.primaryText,
        placeHolderTextColor: AppColor.secondaryText,
        sendButtonIconColor: AppColor.primaryBlue,
        sendButtonIconBackgroundColor: AppColor.primaryBlue,
        dividerColor: AppColor.dividerGrey,
        auxiliaryButtonIconColor: AppColor.secondaryText,
        secondaryButtonIconColor: AppColor.secondaryText,
      );

  // Compact Message Composer (for chat conversation)
  static CometChatCompactMessageComposerStyle get compactComposerStyle =>
      CometChatCompactMessageComposerStyle(
        backgroundColor: AppColor.pureWhite,
        composeBoxBackgroundColor: AppColor.veryLightGrey,
        textColor: AppColor.primaryText,
        placeholderTextColor: AppColor.secondaryText,
        sendButtonIconColor: AppColor.pureWhite,
        sendButtonBackgroundColor: AppColor.primaryBlue,
        dividerColor: AppColor.dividerGrey,
        auxiliaryButtonIconColor: AppColor.secondaryText,
      );

  // Message Header
  static CometChatMessageHeaderStyle get messageHeaderStyle =>
      CometChatMessageHeaderStyle(
        backgroundColor: AppColor.pureWhite,
        titleTextColor: AppColor.primaryText,
        subtitleTextColor: AppColor.secondaryText,
        backIconColor: AppColor.primaryBlue,
        onlineStatusColor: AppColor.successGreen,
        menuIconColor: AppColor.primaryBlue,
        newChatIconColor: AppColor.primaryBlue,
        chatHistoryIconColor: AppColor.primaryBlue,
      );

  // Users List
  static CometChatUsersStyle get usersStyle => CometChatUsersStyle(
    backgroundColor: AppColor.pureWhite,
    titleTextColor: AppColor.primaryText,
    itemTitleTextColor: AppColor.primaryText,
    separatorColor: AppColor.dividerGrey,
    searchBackgroundColor: AppColor.veryLightGrey,
    searchIconColor: AppColor.secondaryText,
    searchPlaceHolderTextColor: AppColor.secondaryText,
    backIconColor: AppColor.primaryBlue,
    submitIconColor: AppColor.primaryBlue,
    checkboxSelectedIconColor: AppColor.primaryBlue,
    checkBoxCheckedBackgroundColor: AppColor.primaryBlue,
  );

  // Groups List
  static CometChatGroupsStyle get groupsStyle => CometChatGroupsStyle(
    backgroundColor: AppColor.pureWhite,
    titleTextColor: AppColor.primaryText,
    itemTitleTextColor: AppColor.primaryText,
    itemSubtitleTextColor: AppColor.secondaryText,
    separatorColor: AppColor.dividerGrey,
    searchBackgroundColor: AppColor.veryLightGrey,
    searchIconColor: AppColor.secondaryText,
    searchPlaceHolderTextColor: AppColor.secondaryText,
    backIconColor: AppColor.primaryBlue,
    submitIconColor: AppColor.primaryBlue,
    checkboxSelectedIconColor: AppColor.primaryBlue,
    checkBoxCheckedBackgroundColor: AppColor.primaryBlue,
  );

  // Search
  static CometChatSearchStyle get searchStyle => CometChatSearchStyle(
    backgroundColor: AppColor.pureWhite,
    searchBackgroundColor: AppColor.veryLightGrey,
    searchTextColor: AppColor.primaryText,
    searchPlaceHolderTextColor: AppColor.secondaryText,
    searchBackIconColor: AppColor.primaryBlue,
    searchClearIconColor: AppColor.secondaryText,
    searchFilterChipBackgroundColor: AppColor.veryLightGrey,
    searchFilterChipSelectedBackgroundColor: AppColor.primaryBlue,
    searchFilterChipTextColor: AppColor.secondaryText,
    searchFilterChipSelectedTextColor: AppColor.pureWhite,
    searchSectionHeaderTextColor: AppColor.secondaryText,
    searchSeeMoreColor: AppColor.primaryBlue,
  );

  // Call Buttons Style
  static CometChatCallButtonsStyle get callButtonsStyle =>
      CometChatCallButtonsStyle(
        voiceCallButtonColor: AppColor.primaryBlue10,
        videoCallButtonColor: AppColor.primaryBlue10,
        voiceCallIconColor: AppColor.primaryBlue,
        videoCallIconColor: AppColor.primaryBlue,
      );

  // Incoming Call Style
  static CometChatIncomingCallStyle get incomingCallStyle =>
      CometChatIncomingCallStyle(
        backgroundColor: AppColor.pureWhite,
        titleColor: AppColor.primaryText,
        subtitleColor: AppColor.secondaryText,
        acceptButtonColor: AppColor.successGreen,
        declineButtonColor: AppColor.alertRed,
      );

  // Outgoing Call Style
  static CometChatOutgoingCallStyle get outgoingCallStyle =>
      CometChatOutgoingCallStyle(
        backgroundColor: AppColor.pureWhite,
        titleColor: AppColor.primaryText,
        subtitleColor: AppColor.secondaryText,
        declineButtonColor: AppColor.alertRed,
      );
}
