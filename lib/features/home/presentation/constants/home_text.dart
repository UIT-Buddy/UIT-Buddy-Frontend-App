class HomeText {
  // Header
  static const String welcomeBack = 'Welcome back';

  // Selection options
  static const String selectionWebsites = 'Websites';
  static const String selectionNote = 'Note';
  static const String selectionWeather = 'Weather';
  static const String selectionMore = 'More';
  static const String userName = 'Đình Minh! 👋';
  static const String classThisEvening = 'You got 1 class this evening';

  // Deadline section
  static const String deadlineSectionTitle = 'Incoming Deadline (3)';
  static const String deadlineSeeAll = 'See all';
  static String deadlineSectionSubtitle(int count) =>
      '$count upcoming deadline${count == 1 ? '' : 's'}';

  // Note screen
  static const String noteDefaultTitle = 'Untitled Note';
  static const String noteSaveButton = 'Save';
  static const String noteEditLabel = 'Edit';
  static const String notePreviewLabel = 'Preview';
  static const String noteEditHint =
      'Write your note here using Markdown...\n\n'
      '# Heading\n**Bold** _Italic_ `code`\n- List item';

  // Website screen
  static const String websiteTitle = 'Websites';
  static const String websiteSubtitle = 'Quick access to UIT portals';
  static const String websiteSearchHint = 'Search websites...';

  // Next class card
  static const String incomingBadge = 'INCOMING (15 MINS)';
  static const String nextClassCode = 'SE100.Q21';
  static const String nextClassName =
      'Phương pháp phát triển phần mềm hướng đối tượng';
  static const String nextClassRoom = 'B2.14';
  static const String nextClassLecturer = 'TS. Lê Thanh Trọng';
}
