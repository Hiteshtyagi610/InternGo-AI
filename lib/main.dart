import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intern_go/core/firebase_options.dart';
import 'package:intern_go/auth/starting_screen.dart';

import 'package:provider/provider.dart';
import 'package:intern_go/internships/cover_letter_page.dart'; // Contains ChatProvider
import 'package:intern_go/internships/resume_generator_page.dart'; // New ResumeChatProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ResumeChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intern-Go',
      debugShowCheckedModeBanner: false,
      home: const StartingScreen(),
    );
  }
}
