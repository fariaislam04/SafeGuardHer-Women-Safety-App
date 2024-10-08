<h1 align="center" style="font-size: 52px;" ><img height=30 src="https://i.ibb.co.com/b3yN7PJ/logo.png"> SafeGuardHer: Women Safety App</h1>

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

SafeGuardHer/ <br>
├── lib/ <br>
│ ├── main.dart <br>
│ ├── screens/ <br>
│ │ ├── home_screen.dart <br>
│ │ ├── record_screen.dart <br>
│ │ ├── track_me_screen.dart <br>
│ ├── constants/ <br>
│ │ ├── util/ <br>
│ │ │ ├── timer_util.dart/ <br>
│ ├── widgets/ <br>
│ │ ├── app_bar.dart <br>
│ │ ├── bottom_navbar.dart <br>
│ │ ├── panic_button_widget.dart <br>
├── assets/ <br>
│ ├── fonts/ <br>
│ ├── illustrations/ <br>
│ ├── logos/ <br>
│ ├── icons/ <br>
├── test/ <br>
│ ├── widget_test.dart <br>
├── README.md <br>
├── pubspec.yaml <br>
├── android/ <br>
├── ios/ <br>
└── build/ <br>
