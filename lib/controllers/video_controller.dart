import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  RxString durationString = "00:00:00".obs;
  Timer? _timer;
  int _seconds = 0;
  String? sessionId;

  @override
  void onInit() {
    super.onInit();
    sessionId = Get.arguments as String?;
    startCall();
  }

  void startCall() {
     _seconds = 0;
     durationString.value = "00:00:00";
     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
       _seconds++;
       _updateDuration();
     });
  }

  void _updateDuration() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    durationString.value = 
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> endCall() async {
    _timer?.cancel();
    if (sessionId != null) {
      await _db.collection('sessions').doc(sessionId).update({
        'status': 'completed',
        'endTime': FieldValue.serverTimestamp(),
        'duration': durationString.value
      });
    }
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
