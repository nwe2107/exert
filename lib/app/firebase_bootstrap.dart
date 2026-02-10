import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<FirebaseApp?> initializeFirebaseApp() async {
  try {
    return await Firebase.initializeApp();
  } on Exception catch (error) {
    debugPrint(
      'Firebase initialization failed. Falling back to local auth. Error: $error',
    );
    return null;
  }
}
