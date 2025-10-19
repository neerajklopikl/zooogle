import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/providers/theme_provider.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// The main entry point of the application.
Future<void> main() async {
  // Load the environment variables from the .env file.
  // The file to load is determined by the APP_ENV environment variable.
  // To run in production, use: flutter run --dart-define=APP_ENV=prod
  await dotenv.load(fileName: ".env.${const String.fromEnvironment('APP_ENV', defaultValue: 'dev')}");
  
  runApp(
    // We wrap the entire app in a ChangeNotifierProvider.
    // This "provides" the ThemeProvider to all widgets in the app.
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
