import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listium/core/ui/my_colors.dart';
import 'package:listium/firebase_options.dart';
import 'package:listium/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listium App',
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.brown),
        scaffoldBackgroundColor: MyColors.green,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: MyColors.red,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 72,
          centerTitle: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: MyColors.blue,
        ),
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
