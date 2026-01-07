# Notes App

A Flutter application for creating and managing personal notes, built with Firebase for authentication and data storage.

## Features

- **User Authentication**: Secure login and registration using email and password.
- **Note Management**: Create, view, and manage personal notes.
- **Real-time Sync**: Notes are synchronized across devices using Firebase Firestore.
- **Offline Support**: Basic offline viewing (with online sync required for updates).
- **Responsive UI**: Clean and intuitive user interface built with Flutter.
- **State Management**: Uses BLoC pattern for predictable state management.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore)
- **State Management**: BLoC (Business Logic Component)
- **Database**: Firebase Firestore (NoSQL)
- **Authentication**: Firebase Auth
- **Other Libraries**:
  - `flutter_bloc`: For state management
  - `equatable`: For value comparison
  - `connectivity_plus`: For network connectivity checks

## Project Setup Steps

1. **Install Flutter**: Ensure you have Flutter installed on your machine. Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).

2. **Clone the Repository**: Clone this project to your local machine.
   ```
   git clone <repository-url>
   cd notes-app
   ```

3. **Install Dependencies**: Run the following command to install all required packages.
   ```
   flutter pub get
   ```

4. **Set up Firebase**:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable Authentication (Email/Password) and Firestore Database.
   - Download the `google-services.json` for Android and place it in `android/app/`.
   - For iOS, configure the iOS app in Firebase and download `GoogleService-Info.plist` to `ios/Runner/`.
   - Update `lib/firebase_options.dart` with your Firebase configuration if necessary.

5. **Run Code Generation** (if needed): If using code generation tools, run:
   ```
   flutter pub run build_runner build
   ```

## How to Run the App Locally

1. Ensure you have an emulator or connected device.
2. Run the app using:
   ```
   flutter run
   ```
   This will build and launch the app on the connected device or emulator.

## Database Schema / Collections / Tables

The app uses **Firebase Firestore** as the database.

- **Collections**:
  - `users/{userId}/notes/{noteId}`: A subcollection under each user document to store notes.
    - **Fields**:
      - `title` (String): The title of the note.
      - `content` (String): The content/body of the note.
      - `createdAt` (Timestamp): Date and time when the note was created.
      - `updatedAt` (Timestamp): Date and time when the note was last updated.
      - `userId` (String): The ID of the user who owns the note.

Each user has their own subcollection of notes, ensuring data isolation.

## Authentication Approach Used

The app uses **Firebase Authentication** for user management.
- **Method**: Email and password authentication.
- Users must register and log in to access their notes.
- Authentication state is managed using Firebase Auth SDK, integrated with the BLoC pattern for state management.

## Assumptions or Trade-offs Made

- **Assumptions**:
  - Users have a stable internet connection for Firebase services.
  - Firebase project is properly configured and accessible.
  - Users will authenticate before accessing notes.

- **Trade-offs**:
  - **Dependency on Firebase**: Relies on Google services, which may have usage limits and costs for high-volume usage.
  - **Real-time Sync**: Firestore provides real-time updates, but this increases data transfer and potential battery usage on mobile devices.
  - **Platform Limitation**: Currently configured for Android and iOS; web and desktop support would require additional Firebase configuration.
  - **Security**: Data is stored per user, but relies on Firebase's security rules (not explicitly defined in code; assumes default or custom rules are set).
  - **Offline Capability**: No offline persistence implemented; notes require internet to sync.

## Architecture

The app follows a clean architecture pattern with separation of concerns:

- **Presentation Layer**: UI screens and widgets (views).
- **Business Logic Layer**: BLoC classes handling events and states.
- **Data Layer**: Services for API calls and data models.
- **Domain Layer**: Models and business rules.

### Folder Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── routes.dart               # App routing
├── note_service.dart         # Firebase service for notes
├── screens/                  # UI screens
│   └── home/
│       ├── home_screen.dart
│       ├── bloc.dart
│       ├── state.dart
│       ├── event.dart
│       └── model.dart
├── create note/              # Create note feature
├── notes details/            # Note details feature
├── register/                 # Registration feature
├── login/                    # Login feature
└── splash/                   # Splash screen
```

## Screenshots

*(Add screenshots here when available)*

- Login Screen
- Home Screen with Notes List
- Create Note Screen
- Note Details Screen

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please contact [your-email@example.com].
