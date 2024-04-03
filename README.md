# LinkedIn Post Saver

LinkedIn Post Saver is a simple Flutter application that allows users to save LinkedIn posts categorized by different categories and store them in Firebase Firestore.

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

2. Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/).

3. Add a Flutter app to your Firebase project and follow the setup instructions to add Firebase configuration files to your Flutter app.

4. Add the necessary Firebase packages to your Flutter app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cloud_firestore: ^2.5.2
```

5. Initialize Firebase in your Flutter app. Follow the instructions provided by Firebase after adding your app to the Firebase project.

6. Run the app on your preferred device or emulator:

```bash
flutter run
```

## Usage

- Launch the app on your device or emulator.
- Add a new LinkedIn post by selecting a category or entering a new one and providing the LinkedIn post link.
- View all saved posts categorized by their respective categories.
- To remove a post, tap on the delete icon next to the post.

## Contributing

Contributions are welcome! Feel free to open issues or pull requests for any improvements or features you'd like to see in the app.
