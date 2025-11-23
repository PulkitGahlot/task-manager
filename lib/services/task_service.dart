import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskService {
  static Box<Task> get _box => Hive.box<Task>('tasks');

  // Get all tasks
  static List<Task> getAllTasks() {
    return _box.values.toList();
  }

  // Add a new task
  static Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  // Update a task
  static Future<void> updateTask(Task task) async {
    await task.save();
  }

  // Delete a task
  static Future<void> deleteTask(String taskId) async {
    await _box.delete(taskId);
  }

  // Get tasks for a specific date
  static List<Task> getTasksForDate(DateTime date) {
    return _box.values
        .where((task) => task.shouldAppearOnDate(date))
        .toList();
  }

  // Toggle task completion for a specific date
  static Future<void> toggleTaskCompletion(Task task, DateTime date) async {
    if (task.isCompletedForDate(date)) {
      task.removeCompletionForDate(date);
    } else {
      task.markCompletedForDate(date);
    }
    await task.save();
  }
}

