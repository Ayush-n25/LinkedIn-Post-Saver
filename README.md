# LinkedIn Post Saver

LinkedIn Post Saver is a simple Flutter application that allows users to save LinkedIn posts categorized by different categories and store them in Local Storage.

## Features

- Save LinkedIn posts with categories.
- View all saved posts categorized by their respective categories.
- Remove posts when necessary.
- Connect with Firebase Firestore to store and retrieve posts.

## Setup

1. Clone this repository to your local machine:

```bash
git clone https://github.com/Ayush-n25/LinkedIn-Post-Saver.git
```

2. Set up a Flutter project and download all the dependencies in pubspec.yml file

```yaml
dependencies:
  flutter:
    sdk: flutter
  path_provider: ^2.1.3
  clipboard: 0.1.3
```

3. Run the flutter project

```cmd
flutter run
```

4. (optional) run flutter build apk --release and find apk in build/app/outputs/flutter-apk/app-release.apk
```cmd
flutter build apk --release
```

## Usage

- Launch the app on your device or emulator.
- Add a new LinkedIn post by selecting a category or entering a new one and providing the LinkedIn post link.
- View all saved posts categorized by their respective categories.
- To remove a post, tap on the delete icon next to the post.
