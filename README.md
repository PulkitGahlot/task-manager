# Task Manager App 📱

A beautiful and intuitive Flutter application for managing daily tasks and chores with a reward-based system. This app helps users (especially kids) track their tasks, earn stars for completion, and stay organized with a clean, modern UI that supports both light and dark themes.

## ✨ Features

### 🏠 Home Screen
- **Date-based Task Filtering**: View tasks filtered by selected date
- **Weekly Calendar Strip**: Navigate through the week (Sunday to Saturday) with visual date selection
- **Task Organization**: Tasks are grouped by their start date with clear separators
- **Task Completion Tracking**: Mark tasks as completed/uncompleted with a simple tap
- **Real-time Updates**: Tasks appear immediately after creation without manual refresh
- **Anytime vs Scheduled Tasks**: Separate sections for flexible and time-specific tasks
- **Profile & Stars Display**: View user profile and current star balance in the app bar

### ➕ Add Task Screen
- **Custom Task Creation**: Create tasks with custom titles and descriptions
- **Icon Selection**: Choose from a variety of emoji icons for visual task identification
- **Reward System**: Set stars (coins) earned per task completion
- **Flexible Scheduling**:
  - Start date selection
  - Repeat patterns: Every Day, Every Week, Every Month, or One Time
  - Time settings: Anytime or specific time with reminders
- **Photo Proof Option**: Enable photo verification for task completion (premium feature indicator)
- **Intuitive UI**: Clean, card-based design with easy-to-use controls

### 💾 Data Persistence
- **Local Storage**: All tasks are saved locally using Hive database
- **Offline Support**: Works completely offline, no internet connection required
- **Data Persistence**: Tasks and completion status persist across app restarts

### 🎨 UI/UX
- **Dark/Light Mode**: Automatic theme switching based on system preferences
- **Brand Colors**: Consistent orange (#FF6B35) brand color throughout the app
- **Modern Design**: Material Design 3 with smooth animations
- **Responsive Layout**: Optimized for various screen sizes

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **Local Storage**: Hive (NoSQL database)
- **State Management**: ValueListenableBuilder for reactive UI updates
- **Date Formatting**: intl package
- **Architecture**: Service-based architecture with separation of concerns

## 📦 Dependencies

### Main Dependencies
- `hive: ^2.2.3` - Fast, lightweight NoSQL database
- `hive_flutter: ^1.1.0` - Flutter integration for Hive
- `intl: ^0.19.0` - Internationalization and date formatting

### Dev Dependencies
- `hive_generator: ^2.0.1` - Code generation for Hive type adapters
- `build_runner: ^2.4.8` - Code generation runner
- `flutter_lints: ^5.0.0` - Linting rules for Flutter

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android/iOS emulator or physical device

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/PulkitGahlot/task-manager.git
   cd task-manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive type adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Add profile image asset**
   - Place your profile image at: `assets/profile_image/pfp.png`
   - Ensure the asset path is correctly configured in `pubspec.yaml`

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point, Hive initialization
├── models/
│   ├── task.dart            # Task model with Hive annotations
│   └── task.g.dart          # Generated Hive type adapter
├── screens/
│   ├── home_screen.dart     # Main screen with task list and calendar
│   └── add_task_screen.dart # Task creation screen
└── services/
    └── task_service.dart    # Task CRUD operations and business logic
```

## 🎯 Usage Guide

### Creating a Task

1. Tap the **+** button in the top-right corner of the Home Screen
2. Fill in the task details:
   - **Title**: Enter a task name (required)
   - **Description**: Add optional details
   - **Icon**: Tap the edit icon to choose an emoji
   - **Stars**: Adjust reward points using +/- buttons
   - **Start Date**: Select when the task should begin
   - **Repeat**: Choose frequency (Every Day, Week, Month, or One Time)
   - **Time**: Set to "Anytime" or enable specific time with reminders
   - **Photo Proof**: Toggle if photo verification is required
3. Tap **Add** in the app bar to save

### Managing Tasks

- **View Tasks**: Tasks appear on the Home Screen filtered by the selected date
- **Complete Task**: Tap the circular checkbox next to a task to mark it complete
- **Date Navigation**: Swipe or tap dates in the calendar strip to view different days
- **Task Grouping**: Tasks are automatically grouped by their start date

### Navigation

- **Bottom Navigation**: 
  - **Tasks Tab**: View and manage your tasks (active - green)
  - **Rewards Tab**: Access rewards section (coming soon)

## 🔧 Development

### Code Generation

After modifying the `Task` model, regenerate the Hive adapter:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Key Features Implementation

- **Hive Setup**: Initialized in `main.dart` before app start
- **Reactive UI**: `ValueListenableBuilder` listens to Hive box changes
- **Date Filtering**: Tasks filtered by `shouldAppearOnDate()` method
- **Completion Tracking**: Stored as timestamps for Hive compatibility

## 📱 Screens

### Home Screen
- Profile section with user name and avatar
- Stars balance display
- Add task button
- Date display with calendar strip (Sunday-Saturday)
- Task list with completion checkboxes
- Date separators for task grouping
- Bottom navigation bar

### Add Task Screen
- Task icon with edit option
- Title and description fields
- Stars per completion controls
- Scheduling options (date, repeat pattern)
- Time settings with toggle
- Photo proof toggle
- Save/Cancel actions in app bar

## 🎨 Design System

- **Primary Color**: Orange (#FF6B35)
- **Accent Color**: Gold (#FFD700) for stars
- **Success Color**: Green for completed tasks
- **Theme**: Material Design 3 with system theme support

## 📝 Notes

- Tasks are stored locally using Hive - no cloud backup by default
- Profile image should be placed in `assets/profile_image/pfp.png`
- The app automatically adapts to system dark/light mode
- All dates are normalized to start of day for accurate comparison

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 👨‍💻 Author

**Pulkit Gahlot**

[Linkedin](https://linkedin.com/in/pulkit-gahlot)
[Github](https://github.com/PulkitGahlot)

