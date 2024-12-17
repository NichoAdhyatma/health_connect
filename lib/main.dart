import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_connect/health_connect_integration.dart';
import 'package:health_connect/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();




  runApp(const HealthConnectIntegration());
}
