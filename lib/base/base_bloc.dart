import 'package:get/get.dart';

abstract class BaseBloc extends GetxController {
  final isLoading = false.obs;
  final alertMessage = "".obs;
}