import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/controller/calendar_controller.dart';
import 'package:health_connect/controller/health_connect_controller.dart';
import 'package:health_connect/widgets/authorize_button.dart';
import 'package:health_connect/widgets/calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityPage extends GetView<HealthConnectController> {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HealthConnectController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return AuthorizeButton(
                  isAuthorized: controller.isAuthorized.value,
                  onAuthorize: controller.authorizeHealthConnect,
                  onRevoke: controller.revokeHealthConnect,
                );
              }),
              CalendarWidget(
                onDayChange: (date) {
                  log("$date", name: "Change DateTime");
                  controller.fetchHealthData(date: date);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
