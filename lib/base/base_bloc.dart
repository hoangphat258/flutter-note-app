import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class BaseBloc extends GetxController {
  final isLoading = false.obs;
  final alertMessage = "".obs;
  final connectivity = Rx(ConnectivityResult.none);

  BaseBloc() {
    Connectivity().checkConnectivity().then((value) => connectivity.value = value);
    Connectivity().onConnectivityChanged.listen((event) => connectivity.value = event);
  }
}