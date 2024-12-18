import 'package:get/get.dart';
import 'package:health_connect/core/utils.dart';

class CalendarController extends GetxController {
  Rx<DateTime> selectedDate = Rx(DateTime.now().toLocal().date);

}