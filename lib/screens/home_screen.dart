import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int totalStars = 30; // This could be calculated from completed tasks
  int _selectedTab = 0; // 0 for Tasks, 1 for Rewards

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = const Color(0xFFFF6B35); // Orange brand color

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      appBar: _buildAppBar(isDark, brandColor),
      bottomNavigationBar: _buildBottomNavigationBar(isDark, brandColor),
      body: SafeArea(
        child: Column(
          children: [
            // Date and calendar section
            _buildDateSection(isDark, brandColor),
            
            // Task list
            Expanded(
              child: _buildTaskList(isDark, brandColor),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark, Color brandColor) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile section
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isDark ? Colors.white.withOpacity(0.3) : Colors.grey[200],
                child: Image.asset(
                  'assets/profile_image/pfp.png', 
                  width: 32, 
                  height: 32, 
                  fit: BoxFit.cover
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'John',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
          // Stars badge and Add button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      '$totalStars',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Add button
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTaskScreen()),
                  );
                  // Force refresh by updating selectedDate
                  if (mounted) {
                    setState(() {
                      // This will trigger a rebuild
                    });
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(bool isDark, Color brandColor) {
    final today = DateTime.now();
    final isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

    return Column(
      children: [
        // Date text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isToday
                  ? 'Today, ${DateFormat('MMM d').format(selectedDate)}'
                  : DateFormat('MMM d').format(selectedDate),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Calendar strip
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 7,
            itemBuilder: (context, index) {
              // Find Sunday of the current week
              final todayWeekday = today.weekday; // 1 = Monday, 7 = Sunday
              final daysToSunday = todayWeekday == 7 ? 0 : todayWeekday;
              final sundayOfWeek = today.subtract(Duration(days: daysToSunday));
              
              // Start from Sunday and add index days
              final date = sundayOfWeek.add(Duration(days: index));
              final isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;
              final isCurrentDay = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? brandColor
                              : (isCurrentDay
                                  ? brandColor.withValues(alpha: 0.2)
                                  : Colors.transparent),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTaskList(bool isDark, Color brandColor) {
    return ValueListenableBuilder<Box<Task>>(
      valueListenable: Hive.box<Task>('tasks').listenable(),
      builder: (context, box, _) {
        // Use box.values directly to ensure proper updates
        final allTasks = box.values.toList();
        
        // Group tasks by their start date
        final Map<String, List<Task>> tasksByDate = {};
        
        for (var task in allTasks) {
          if (task.shouldAppearOnDate(selectedDate)) {
            // Get the date when this task starts/appears
            final taskDate = task.startDate;
            final dateKey = DateFormat('MMM d, yyyy').format(taskDate);
            
            if (!tasksByDate.containsKey(dateKey)) {
              tasksByDate[dateKey] = [];
            }
            tasksByDate[dateKey]!.add(task);
          }
        }

        // Sort dates
        final sortedDates = tasksByDate.keys.toList()..sort((a, b) {
          final dateA = DateFormat('MMM d, yyyy').parse(a);
          final dateB = DateFormat('MMM d, yyyy').parse(b);
          return dateA.compareTo(dateB);
        });

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            if (sortedDates.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No tasks for this date',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              )
            else
              ...sortedDates.expand((dateKey) {
                final tasks = tasksByDate[dateKey]!;
                final anytimeTasks = tasks.where((task) => task.timeOfDay == 'Anytime').toList();
                final scheduledTasks = tasks.where((task) => task.timeOfDay != 'Anytime').toList();
                
                return [
                  // Date separator
                  _buildDateSeparator(dateKey, isDark, brandColor),
                  const SizedBox(height: 12),
                  // Anytime section
                  if (anytimeTasks.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.refresh, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'ANYTIME',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...anytimeTasks.map((task) => _buildTaskCard(task, isDark, brandColor)),
                    if (scheduledTasks.isNotEmpty) const SizedBox(height: 12),
                  ],
                  // Scheduled tasks
                  ...scheduledTasks.map((task) => _buildTaskCard(task, isDark, brandColor)),
                  const SizedBox(height: 24),
                ];
              }),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(String dateKey, bool isDark, Color brandColor) {
    final today = DateTime.now();
    final date = DateFormat('MMM d, yyyy').parse(dateKey);
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: brandColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isToday ? 'Today, $dateKey' : dateKey,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isDark, Color brandColor) {
    final isCompleted = task.isCompletedForDate(selectedDate);
    final timeText = task.time != null
        ? DateFormat('h:mma').format(task.time!).toLowerCase()
        : 'Anytime';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Completion checkbox
          GestureDetector(
            onTap: () {
              TaskService.toggleTaskCompletion(task, selectedDate);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // Task icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                task.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Stars
          Row(
            children: [
              Text(
                '${task.starsPerCompletion}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.star,
                color: Color(0xFFFFD700),
                size: 20,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Speaker icon
          Icon(
            Icons.volume_up,
            color: const Color(0xFFFFD700),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDark, Color brandColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tasks tab
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = 0;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? Colors.green : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: _selectedTab == 0 ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedTab == 0 ? FontWeight.w500 : FontWeight.normal,
                        color: _selectedTab == 0 
                            ? (isDark ? Colors.white : Colors.black87)
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              // Rewards tab
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = 1;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? Colors.green : isDark ? Colors.white.withOpacity(0.3) : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedTab == 1 ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: _selectedTab == 1 ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedTab == 1 ? FontWeight.w500 : FontWeight.normal,
                        color: _selectedTab == 1 
                            ? (isDark ? Colors.white : Colors.black87)
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

