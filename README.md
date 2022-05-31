# flutter-note-app
## Project Overview
This is a simple note app that using local storage (SQL) and firestore database. This project uses GetX for state management.

## Code Structure
- All structure folders are stored at ***lib*** folder:
  + base: contains all base classes. In this simple project, it just has 1 class (**BaseBloc**)
  + di: contains **AppBinding** of GetX to make dependency injection.
  + model: all models returned by the server.
  + modules: contains all screens.
- Libraries and frameworks: GetX, Firebase Authenticate, Firestore, SQFLite.

***NOTE: This application is configured for Android only. iOS maybe later***
