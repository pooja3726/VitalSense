import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VitalSenseApp());
}

class VitalSenseApp extends StatelessWidget {
  const VitalSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VitalSense',
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
