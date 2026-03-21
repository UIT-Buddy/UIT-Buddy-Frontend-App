class DateTimeUtils {
  static String getTimeAgo(DateTime dateTime) {
    final nowInUtc = DateTime.now().subtract(
      Duration(hours: 7),
    ); // because the dateTime in backend is in UTC+0
    final diff = nowInUtc.difference(dateTime);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      final weeks = (diff.inDays / 7).floor();
      if (weeks < 4) {
        return '${weeks}w ago';
      } else {
        final months = (diff.inDays / 30).floor();
        if (months < 12) {
          return '${months}mo ago';
        } else {
          final years = (diff.inDays / 365).floor();
          return '${years}y ago';
        }
      }
    }
  }
}
