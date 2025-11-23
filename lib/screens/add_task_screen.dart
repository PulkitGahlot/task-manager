import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _icon = '🦷'; // Default icon
  int _starsPerCompletion = 20;
  DateTime _startDate = DateTime.now();
  String _repeatPattern = 'Every Day';
  String _timeOfDay = 'Anytime';
  bool _timeEnabled = false;
  TimeOfDay? _selectedTime;
  bool _photoProof = false;

  final List<String> _repeatOptions = ['Every Day', 'Every Week', 'Every Month', 'One Time'];
  final List<String> _timeOfDayOptions = ['Anytime', 'Specific Time'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = const Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: brandColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Task',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'Add',
              style: TextStyle(
                color: brandColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task icon
            _buildTaskIcon(isDark, brandColor),
            const SizedBox(height: 24),
            
            // Task description card
            _buildDescriptionCard(isDark),
            const SizedBox(height: 16),
            
            // Stars per completion
            _buildStarsSection(isDark, brandColor),
            const SizedBox(height: 16),
            
            // Scheduling section
            _buildSchedulingSection(isDark, brandColor),
            const SizedBox(height: 16),
            
            // Time settings
            _buildTimeSettingsSection(isDark, brandColor),
            const SizedBox(height: 16),
            
            // Photo proof
            _buildPhotoProofSection(isDark, brandColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskIcon(bool isDark, Color brandColor) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _icon,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _selectIcon,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Task title',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            decoration: InputDecoration(
              hintText: 'Task description',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStarsSection(bool isDark, Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STARS PER COMPLETION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_starsPerCompletion > 0) {
                    setState(() {
                      _starsPerCompletion--;
                    });
                  }
                },
                icon: Icon(Icons.remove, color: Colors.green),
              ),
              Row(
                children: [
                  Text(
                    '$_starsPerCompletion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Color(0xFFFFD700), size: 24),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _starsPerCompletion++;
                  });
                },
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedulingSection(bool isDark, Color brandColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingRow(
            'Start Date',
            _startDate == DateTime.now()
                ? 'Today'
                : DateFormat('MMM d, yyyy').format(_startDate),
            () => _selectStartDate(),
            isDark,
          ),
          const Divider(),
          _buildSettingRow(
            'Repeat',
            _repeatPattern,
            () => _selectRepeatPattern(),
            isDark,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettingsSection(bool isDark, Color brandColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingRow(
            'Time of Day',
            _timeOfDay,
            () => _selectTimeOfDay(),
            isDark,
            showArrow: true,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (_timeEnabled && _selectedTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Set a time to remind the kid when it\'s due',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                ],
              ),
              Switch(
                value: _timeEnabled,
                onChanged: (value) {
                  setState(() {
                    _timeEnabled = value;
                    if (value && _selectedTime == null) {
                      _selectedTime = TimeOfDay.now();
                    }
                  });
                },
                activeThumbColor: brandColor,
              ),
            ],
          ),
          if (_timeEnabled && _selectedTime != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedTime!.format(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoProofSection(bool isDark, Color brandColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Photo Proof',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.diamond,
                color: brandColor,
                size: 16,
              ),
            ],
          ),
          Switch(
            value: _photoProof,
            onChanged: (value) {
              setState(() {
                _photoProof = value;
              });
            },
            activeThumbColor: brandColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    String label,
    String value,
    VoidCallback onTap,
    bool isDark, {
    bool showArrow = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectIcon() {
    // Simple icon picker - you can enhance this later
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: ['🦷', '📚', '👶', '🏃', '🍎', '🧹', '🎮', '🎨']
              .map((icon) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _icon = icon;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(icon, style: const TextStyle(fontSize: 40)),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  void _selectRepeatPattern() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _repeatOptions.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  _repeatPattern = option;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _selectTimeOfDay() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _timeOfDayOptions.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  _timeOfDay = option;
                  if (option == 'Anytime') {
                    _timeEnabled = false;
                  }
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? '${_titleController.text}. You\'ll get $_starsPerCompletion coins'
          : _descriptionController.text,
      icon: _icon,
      starsPerCompletion: _starsPerCompletion,
      startDate: _startDate,
      repeatPattern: _repeatPattern,
      timeOfDay: _timeOfDay,
      time: _timeEnabled && _selectedTime != null
          ? DateTime(
              _startDate.year,
              _startDate.month,
              _startDate.day,
              _selectedTime!.hour,
              _selectedTime!.minute,
            )
          : null,
      photoProof: _photoProof,
    );

    await TaskService.addTask(task);
    if (!mounted) return;
    Navigator.pop(context);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task created successfully!')),
    );
  }
}

