import 'package:flutter/material.dart';
import 'package:quizmaster/firebase_options.dart';
import 'package:quizmaster/home/profile.dart';
import 'splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'home/home_screen.dart';  
import 'home/categories_screen.dart';  // Added import
// Added import
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quizmaster/providers/user_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: QuizMasterApp(),
    ),
  );
}

class QuizMasterApp extends StatelessWidget {
  const QuizMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'QuizMaster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),  // Added border radius
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
          '/categories': (context) => CategoriesScreen(),  // Added route
          // QuizListScreen is navigated to directly with arguments
        },
        onGenerateRoute: (settings) {
          // Handle custom transitions
          switch (settings.name) {
            case '/':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => SplashScreen(),
                transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
                transitionDuration: Duration(milliseconds: 300),
              );
            case '/categories':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => CategoriesScreen(),
                transitionsBuilder: (_, a, __, c) =>
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
                    child: c,
                  ),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}