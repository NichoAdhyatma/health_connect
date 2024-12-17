import 'package:flutter/material.dart';
import 'package:health_connect/page/activity_page.dart';

class HealthConnectIntegration extends StatelessWidget {
  const HealthConnectIntegration({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      title: "HealthConnect App",
      home: ActivityPage(),
    );
  }
}
