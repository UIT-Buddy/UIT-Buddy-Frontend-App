import 'package:flutter/material.dart';

// ── Layout dimensions ──────────────────────────────────────────────────────
const double kCourseRowHeight = 36.0;
const double kCoursePeriodColWidth = 28.0;
const double kCourseHeaderRowHeight = 30.0;
const int kCourseTotalPeriods = 10;

/// Height of the Blended-Learning row that appears below the regular grid.
/// Equivalent to 2 regular period rows so course names have room to breathe.
const double kCourseBLRowHeight = kCourseRowHeight * 3;

// dayOfWeek offset: index 0 = Mon (dayOfWeek 2) … index 5 = Sat (dayOfWeek 7)
const int kCourseDayIndexOffset = 2;
const int kCourseTotalDays = 6;

// ── Course colour palette ──────────────────────────────────────────────────
/// Each entry is (backgroundColour, foreground/text colour).
/// 12 entries ensure up to 12 uniquely-coloured courses per semester
/// (lab sections reuse their parent course’s colour and do not consume a slot).
const List<(Color, Color)> kCoursePalette = [
  (Color(0xFFDCEEFF), Color(0xFF1565C0)), //  1 soft blue
  (Color(0xFFD6F5E3), Color(0xFF1B7A3E)), //  2 soft green
  (Color(0xFFFFEDD5), Color(0xFFB94B00)), //  3 soft orange
  (Color(0xFFEDE7F6), Color(0xFF4527A0)), //  4 soft purple
  (Color(0xFFFFE4E8), Color(0xFFC0143C)), //  5 soft red
  (Color(0xFFD4F7F7), Color(0xFF006064)), //  6 soft teal
  (Color(0xFFFFF9C4), Color(0xFF827717)), //  7 soft yellow
  (Color(0xFFFFE0B2), Color(0xFFBF360C)), //  8 soft deep-orange
  (Color(0xFFE8F5E9), Color(0xFF1B5E20)), //  9 soft dark-green
  (Color(0xFFFCE4EC), Color(0xFF880E4F)), // 10 soft pink
  (Color(0xFFE3F2FD), Color(0xFF0D47A1)), // 11 soft indigo
  (Color(0xFFEFEBE9), Color(0xFF3E2723)), // 12 soft brown
];
