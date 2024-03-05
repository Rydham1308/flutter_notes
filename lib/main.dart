import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/home_page/home_page.dart';
import 'package:notes/screens/login/login.dart';
import 'package:notes/screens/login/register_screen.dart';
import 'package:notes/screens/login/splash_screen.dart';
import 'package:notes/screens/profile_screen/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'MundialRegular',
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Login(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/dashboard': (context) => const Dashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
