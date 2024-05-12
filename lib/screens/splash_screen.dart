import "package:flutter/material.dart";
import "package:qasheets/screens/home_screen.dart";
import "package:qasheets/utils/app_styles.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ignore: prefer_const_constructors
    Future.delayed(Duration(seconds: 1),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.dark,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.airplanemode_on_rounded, 
              color: AppTheme.accent, 
              size: 100,
              ),
              SizedBox(height: 20),
              Icon(Icons.airplane_ticket_rounded, color: AppTheme.splash, size: 100,
              ),
              SizedBox(height: 20),
              Text('QA Sheet Quick Builder',
              style: AppTheme.splashStyle
              ),
              SizedBox(height: 20),
              Icon(Icons.airplanemode_on_rounded, color: AppTheme.plane, size: 100,)

           ],
       ),
      )
    );
  }
}