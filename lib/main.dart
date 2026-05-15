import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aether_project/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aether_project/features/world_event/presentation/pages/world_event_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
      title: 'AETHER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.rpgTheme,
      home: const WorldEventScreen(),
    );
  }
}
