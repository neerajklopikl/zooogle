import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/company_provider.dart';
import 'screens/company/company_selection_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.dev");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the app with the CompanyProvider so it's available everywhere
    return ChangeNotifierProvider(
      create: (context) => CompanyProvider(),
      child: MaterialApp(
        title: 'Zooogle',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          cardTheme: const CardThemeData(
            elevation: 1,
            color: Colors.white,
          ),
        ),
        home: const CompanySelectionScreen(),
      ),
    );
  }
}
