class CalendarText {
  // ── Screen header ─────────────────────────────────────────────────────────
  static const String calendarTitle = 'Calendar';
  static const String deadlineMode = 'Deadline';
  static const String coursesMode = 'Courses';

  // ── Courses placeholder ──────────────────────────────────────────────────
  static const String coursesCalendarPlaceholder = 'Courses Calendar';

  // ── Month names ──────────────────────────────────────────────────────────
  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // ── Day abbreviations (Sun → Sat) ─────────────────────────────────────────
  static const List<String> dayAbbreviations = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  // ── Deadline detail section ───────────────────────────────────────────────
  static String upcomingDeadlines(int count) => 'Upcoming ($count)';

  // ── Add deadline modal ────────────────────────────────────────────────────
  static const String addDeadlineTitle = 'New Deadline';
  static const String fieldDeadlineName = 'DEADLINE NAME';
  static const String hintDeadlineName = 'e.g. Lab Report, Assignment 3...';
  static const String fieldCourse = 'COURSE / CLASS';
  static const String hintCourseSearch = 'Search by course code or name...';
  static const String fieldDueDate = 'DUE DATE';
  static const String placeholderSelectDate = 'Select date';
  static const String fieldDueTime = 'DUE TIME';
  static const String placeholderSelectTime = 'Select time';
  static const String buttonCreateDeadline = 'Create Deadline';
  static const String snackbarDeadlineCreated =
      'Deadline created successfully!';
  static const String dateFormatDisplay = 'MMM d, yyyy';
}
