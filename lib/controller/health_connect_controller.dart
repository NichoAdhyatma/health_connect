import 'dart:developer';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:health_connect/core/health_access_mixin_data.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthConnectController extends GetxController
    with HealthAccessDataMixin {
  RxBool isAuthorized = RxBool(false);

  RxList<HealthDataPoint> healthDataList = RxList(<HealthDataPoint>[]);

  RxList<RecordingMethod> recordingMethodsToFilter =
      RxList(<RecordingMethod>[]);

  Future<void> authorizeHealthConnect() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions = await Health().hasPermissions(
      types,
      permissions: permissions,
    );

    if (hasPermissions == null || !hasPermissions) {
      try {
        bool authorized = await Health().requestAuthorization(
          types,
          permissions: permissions,
        );

        isAuthorized.value = authorized;
      } catch (error) {
        log("Exception in authorize: $error");
      }
    } else {
      isAuthorized.value = true;
    }
  }

  Future<void> revokeHealthConnect() async {
    try {
      await Health().revokePermissions();

      isAuthorized.value = false;
    } catch (error) {
      log("Exception in revokeAccess: $error");
    }
  }

  Future<void> fetchHealthData({required DateTime date}) async {
    // get data within the last 24 hours
    final now = date;
    final yesterday = now.subtract(const Duration(hours: 24));

    // Clear old data points
    healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [
          HealthDataType.STEPS,
        ],
        startTime: yesterday,
        endTime: now,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      log('Total number of data points: ${healthData.length}. '
          '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');

      // sort the data points by date
      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

      // save all the new data points (only the first 100)
      healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      log("Exception in getHealthDataFromTypes: $error");
    }

    healthDataList.value = Health().removeDuplicates(healthDataList);

    for (var data in healthDataList) {
      log(toJsonString(data));
    }
  }

  @override
  void onInit() {
    Health().configure();

    Health().getHealthConnectSdkStatus();

    authorizeHealthConnect();

    super.onInit();
  }
}
