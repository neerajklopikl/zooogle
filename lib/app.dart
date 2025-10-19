import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/providers/theme_provider.dart';
import 'screens/home_page.dart';

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We will now use the Consumer to listen for theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Accounting App',
          debugShowCheckedModeBanner: false,

          // 1. Define your main Light Theme
          theme: ThemeData(
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFFFEFBF6),
            brightness: Brightness.light,
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFEFBF6),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            cardTheme: const CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Colors.white,
            )
          ),

          // 2. Define a custom, softer Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFF212121), // A softer, off-black color
            fontFamily: 'Inter',
            cardTheme: const CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Color(0xFF2C2C2C), // A slightly lighter grey for cards
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2C2C2C), // Match card color for consistency
              elevation: 0,
            ),
            // Adjust button themes for better visibility
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.amber.shade200)
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade400,
                foregroundColor: Colors.black87,
              )
            ),
             bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFF2C2C2C),
              selectedItemColor: Colors.amber.shade200,
              unselectedItemColor: Colors.grey.shade400,
            ),
          ),

          // 3. Tell the app which mode to use from the provider
          themeMode: themeProvider.themeMode,
          
          home: const HomePage(),
        );
      },
    );
  }
}
