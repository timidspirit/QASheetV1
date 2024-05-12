import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:qasheets/screens/home_screen.dart';
import 'package:qasheets/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    minimumSize: Size(400, 580),
    size: Size(600, 780),
    center: true,
    title: 'Qasheets',
  );

  windowManager.waitUntilReadyToShow(options, ()async {
    await windowManager.show();
    await windowManager.focus();
  }
);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}