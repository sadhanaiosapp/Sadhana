# Sadhana

Sadhana is an iOS app designed for personal meditation tracking, allowing users to monitor their mindfulness journey while connecting with friends for mutual encouragement. The app helps users stay consistent with their meditation practice and engage in a supportive community.

[Download Sadhana on the App Store](https://apps.apple.com/us/app/sadhana-meditation-tracker/id6504772098)

## Repository Structure

### Sadhana/App
- **SadhanaApp.swift**: The main entry point of the app, setting up the application's environment and primary view hierarchy.

### Sadhana/Components
Contains reusable UI components used throughout the app, including:
- **BottomBlueButton.swift**: Custom button component with a consistent style.
- **CalendarItemView.swift**: Displays individual calendar entries for meditation tracking.
- **FriendRequestView.swift**: Manages friend requests within the app.
- **InputView.swift**: Provides an input field for user data entry.
- **PostView.swift**: Displays posts and updates shared by users.
- **ProfileInitialsView.swift**: Shows user initials as a profile icon.
- **SettingsMyPracticeNavigationLink.swift**: Custom navigation link to the user's practice settings.
- **SettingsRowView.swift**: Represents rows in the settings screen.
- **ToDoListItemView.swift**: Displays individual items for a user's to-do list.

### Sadhana/Core
Core logic and fundamental app features:
- **Authentication**: Handles user login, signup, and authentication processes.
- **Profile**: Manages user profiles and related data.
- **Root**: Contains root-level views and navigation logic.
- **ViewModel**: Manages the state and logic for the app’s various views.

### Sadhana/Model
Defines the data structures and models used in the app:
- **Friend.swift**: Represents a user's friend and their associated data.
- **Post.swift**: Models posts and user updates.
- **ToDoListItem.swift**: Represents individual to-do items.
- **User.swift**: Defines user attributes and basic profile information.
