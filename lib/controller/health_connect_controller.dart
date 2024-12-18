import 'dart:developer';

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

  RxInt totalSteps = RxInt(0);

  @override
  void onInit() {
    Health().configure();

    Health().getHealthConnectSdkStatus();

    authorizeHealthConnect();

    super.onInit();
  }

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
    final start = date;
    final end = start.add(
      const Duration(
        hours: 23,
        minutes: 59,
        seconds: 59,
      ),
    );

    log('Start: $start, End: $end');

    healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [
          HealthDataType.STEPS,
        ],
        startTime: start,
        endTime: end,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      log('Total number of data points: ${healthData.length}. '
          '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');

      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

      healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      log("Exception in getHealthDataFromTypes: $error");
    }

    healthDataList.value = Health().removeDuplicates(healthDataList);

    List<int> dataSteps = healthDataList
        .map((e) => e.value.toJson()['numericValue'] as int)
        .toList();

    log('total data steps: $dataSteps');

    totalSteps.value =
        dataSteps.fold(0, (previousValue, element) => previousValue + element);
  }

  Future<void> fetchStepData({required DateTime date}) async {
    final start = date;
    final end = start.add(
      const Duration(
        hours: 24,
        minutes: 59,
        seconds: 59,
      ),
    );

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
          await Health().requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        int? steps = await Health().getTotalStepsInInterval(start, end);

        log('Total number of steps: $steps');
      } catch (error) {
        log("Exception in getTotalStepsInInterval: $error");
      }
    }
  }
}
