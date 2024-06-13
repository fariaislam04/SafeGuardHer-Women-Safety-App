<h1 align="center" style="font-size: 52px;">SafeGuardHer: Women Safety App</h1>

This is an easy-to-use women safety app designed to provide reliable safety tools for women. 
(App is still under development)

## Problem Statement
Violence against women is a persistent issue, especially in South Asia, where legal protections are often insufficient. This has led to a significant increase in crimes against women, with very few resulting in convictions.

Our mobile app aims to mitigate these issues by continuously monitoring the user's location and offering a way to share their whereabouts with trusted contacts.

## Objectives
The primary objectives of the SafeGuardHer app are:

- Provide real-time GPS tracking for continuous location monitoring.
- Implement two types of panic alerts for immediate emergency assistance.
- Enable audio and video recording for incident documentation.
- Integrate with wearable devices for continuous connectivity.
- Deliver educational resources on personal safety and self-defense.

## Upcoming Features
- **Emergency Alarm:** Users can press a panic button to send alerts to emergency contacts and services.
- **Real-Time GPS Tracking:** Emergency contacts can track the user's location.
- **Incident Recording:** The app records audio and images when the panic button is activated.
- **Wearable Integration:** Seamless integration with smartwatches for easy access to safety features.
- **Unsafe Zone Locator:** Marks areas as unsafe based on reported incidents and alerts users entering these zones.
- **Educational Resources:** Provides safety tips and self-defense techniques.

## Project File Structure

`SafeGuardHer/
├── lib/                                   #contains all the main files
│ ├── main.dart                            #This is where the project starts from
│ ├── screens/                             #Contains all the major screens
│ │ ├── home_screen.dart                   #Contains track me screen, record screen etc.
│ │ ├── record_screen.dart                 #Contains anonymous record screen
│ │ ├── track_me_screen.dart               #Contains map and track-me feature
│ ├── widgets/                             #Contains all widgets for the screens
│ │ ├── app_bar.dart                       #Contains everything related to appbar
│ │ ├── bottom_navbar.dart                 #Contains bottom navigation bar 
│ │ ├── panic_button_widget.dart           #Contains panic button as FloatingActionButton
├── assets/                                #Contains all images, icons etc.
│ ├── illustrations/                       #Contains onBoarding page illustrations etc
│ ├── logos/                               #Contains normal and splash screen logo
│ ├── icons/                               #Contains icons for buttons
├── test/
│ ├── widget_test.dart
├── README.md
├── pubspec.yaml                           #Contains all the dependencies (run: flutter pub get)
├── android/
├── ios/
└── build/`
