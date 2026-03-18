class ChatSettingText {
  // AppBar
  static const String appBarTitle = 'Chat Info';

  // Header
  static String memberCount(int count) => '$count members';
  static const String online = 'Active now';
  static const String offline = 'Offline';

  // Quick actions
  static const String search = 'Search';
  static const String mute = 'Mute';
  static const String unmute = 'Unmute';
  static const String addMember = 'Add member';
  static const String createGroup = 'Create group';
  static const String pinMessage = 'Pin';

  // Customize section
  static const String customizeSectionTitle = 'Customize Chat';
  static const String nicknames = 'Nicknames';
  static const String nicknamesSubtitle = 'Set display names for members';
  static const String theme = 'Theme';
  static const String themeSubtitle = 'Colors and chat background';
  static const String quickEmoji = 'Quick Emoji';
  static const String quickEmojiSubtitle = 'Change your favorite emoji';
  static const String chatPhoto = 'Chat Photo & Avatar';
  static const String chatPhotoSubtitleGroup = 'Change group avatar';
  static const String chatPhotoSubtitle1on1 = 'Chat profile photo';

  // Media & Files section
  static const String mediaSectionTitle = 'Photos & Files';
  static const String mediaTab = 'Photos & Videos';
  static const String filesTab = 'Files';
  static const String noPhotosShared = 'No photos shared yet';
  static const String noFilesShared = 'No files shared yet';
  static const String seeAllPhotos = 'See all photos';
  static const String seeAllFiles = 'See all files';

  // Members section
  static String membersSectionTitle(int count) => 'Members • $count';
  static const String addMemberAction = 'Add member';
  static const String adminBadge = 'Admin';

  // Privacy & Support section
  static const String privacySectionTitle = 'Privacy & Support';
  static const String muteNotifications = 'Mute notifications';
  static const String searchInChat = 'Search in conversation';
  static const String pinnedMessages = 'Pinned messages';
  static const String block = 'Block';
  static const String blockSubtitle =
      'Stop receiving messages from this person';
  static const String leaveGroup = 'Leave group';
  static const String report = 'Report';

  // Leave group dialog
  static const String leaveGroupTitle = 'Leave group?';
  static const String leaveGroupBody =
      'You will no longer receive messages from this group.';
  static const String cancel = 'Cancel';
  static const String leaveConfirm = 'Leave';

  // Nicknames bottom sheet
  static const String nicknameSheetTitle = 'Nicknames';
  static const String nicknameSheetDone = 'Done';
  static String setNicknameFor(String name) => 'Set nickname for $name';
  static const String nicknameHint = 'Enter a nickname...';
  static const String addNickname = 'Add nickname';
  static const String save = 'Save';

  // Create Group screen
  static const String createGroupTitle = 'Create Group';
  static const String groupNameHint = 'Group name';
  static const String createAction = 'Create';

  // Add Member screen
  static const String addMemberTitle = 'Add Members';
  static const String addAction = 'Add';

  // Shared contact picker
  static const String searchContactsHint = 'Search contacts...';
  static const String noContactsFound = 'No contacts found';
  static String selectedCount(int n) => '$n selected';
}
