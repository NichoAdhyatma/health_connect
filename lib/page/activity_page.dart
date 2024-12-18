import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/controller/calendar_controller.dart';
import 'package:health_connect/controller/health_connect_controller.dart';
import 'package:health_connect/widgets/authorize_button.dart';
import 'package:health_connect/widgets/calendar_widget.dart';
import 'package:json_view/json_view.dart';

class ActivityPage extends GetView<HealthConnectController> {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HealthConnectController());

    return GetBuilder<HealthConnectController>(
      initState: (_) {
        CalendarController calendarController = Get.put(CalendarController());

        ever(controller.isAuthorized, (isAuthorized) {
          log("isAuthorized: $isAuthorized", name: "isAuthorized");

          if (isAuthorized) {
            controller.fetchHealthData(
              date: calendarController.selectedDate.value,
            );
            controller.fetchStepData(
              date: calendarController.selectedDate.value,
            );
           }
        });
      },
      builder: (_) => Scaffold(
        body: SafeArea(
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
                  controller.fetchStepData(date: date);
                },
              ),
              Obx(() {
                return Text(
                  "Total Steps: ${controller.totalSteps}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                );
              }),
              Obx(() {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemCount: controller.healthDataList.length,
                    itemBuilder: (context, index) {
                      log("data: ${controller.healthDataList[index]}",
                          name: "HealthDataList");
                      return ListTile(
                        title: Text(
                          controller.healthDataList[index].type.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        subtitle: JsonView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          json: controller.healthDataList[index].toJson(),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
