import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String icon; // Icon identifier or emoji

  @HiveField(4)
  int starsPerCompletion;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  String repeatPattern; // "Every Day", "Every Week", etc.

  @HiveField(7)
  String timeOfDay; // "Anytime" or "Specific Time"

  @HiveField(8)
  DateTime? time; // Specific time if timeOfDay is "Specific Time"

  @HiveField(9)
  bool photoProof;

  @HiveField(10)
  List<int> completedDatesTimestamps; // Store as timestamps for Hive compatibility

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.starsPerCompletion,
    required this.startDate,
    required this.repeatPattern,
    required this.timeOfDay,
    this.time,
    required this.photoProof,
    List<DateTime>? completedDates,
  }) : completedDatesTimestamps = completedDates
            ?.map((d) => DateTime(d.year, d.month, d.day).millisecondsSinceEpoch)
            .toList() ??
        [];

  // Get completed dates as DateTime list
  List<DateTime> get completedDates {
    return completedDatesTimestamps
        .map((timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp))
        .toList();
  }

  // Check if task is completed for a specific date
  bool isCompletedForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final timestamp = normalizedDate.millisecondsSinceEpoch;
    return completedDatesTimestamps.contains(timestamp);
  }

  // Mark task as completed for a specific date
  void markCompletedForDate(DateTime date) {
    // Normalize to start of day for comparison
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final timestamp = normalizedDate.millisecondsSinceEpoch;
    
    if (!completedDatesTimestamps.contains(timestamp)) {
      completedDatesTimestamps.add(timestamp);
    }
  }

  // Remove completion for a specific date
  void removeCompletionForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final timestamp = normalizedDate.millisecondsSinceEpoch;
    completedDatesTimestamps.remove(timestamp);
  }

  // Check if task should appear on a specific date based on repeat pattern
  bool shouldAppearOnDate(DateTime date) {
    if (date.isBefore(startDate)) return false;

    switch (repeatPattern) {
      case 'Every Day':
        return true;
      case 'Every Week':
        // Check if it's the same day of week
        return date.difference(startDate).inDays % 7 == 0;
      case 'Every Month':
        // Check if it's the same day of month
        return date.day == startDate.day;
      default:
        // One time task
        return date.year == startDate.year &&
            date.month == startDate.month &&
            date.day == startDate.day;
    }
  }
}

