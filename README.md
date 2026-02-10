# exert

Offline-first exercise discipline app.

## Firebase setup (auth + accounts)

Firebase auth/account integration is enabled automatically when Firebase is configured on the project.

1. Install FlutterFire CLI:
`dart pub global activate flutterfire_cli`
2. Configure Firebase for this app:
`flutterfire configure`
3. Ensure generated platform files are present:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
4. Run the app.

If Firebase is not configured, the app falls back to local in-memory demo auth:
- Email: `demo@exert.app`
- Password: `exert1234`

## Flutter resources
- [Flutter docs](https://docs.flutter.dev/)
- [FlutterFire docs](https://firebase.flutter.dev/)
