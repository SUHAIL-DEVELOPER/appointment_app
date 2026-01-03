import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/session.dart';
import 'auth_controller.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<Session> sessions = <Session>[].obs;

  @override
  void onReady() {
    super.onReady();
    sessions.bindStream(sessionStream());
  }

  Stream<List<Session>> sessionStream() {
    // Filter by 'upcoming' but sort locally to avoid needing a Firestore Index
    Query query = _db.collection('sessions').where('status', isEqualTo: 'upcoming');
    
    return query
        .snapshots()
        .map((QuerySnapshot query) {
          List<Session> retVal = [];
          for (var element in query.docs) {
            retVal.add(Session.fromMap(element.data() as Map<String, dynamic>, element.id));
          }
          // Filter out sessions that are in the past
          retVal = retVal.where((s) => s.scheduledTime.isAfter(DateTime.now())).toList();
          retVal.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
          return retVal;
        });
  }

  Future<void> joinSession(Session session) async {
    var statusCamera = await Permission.camera.request();
    var statusMic = await Permission.microphone.request();

    if (statusCamera.isGranted && statusMic.isGranted) {
      // Update Firestore
      await _db.collection('sessions').doc(session.sessionId).update({
        'status': 'ongoing',
        'startTime': FieldValue.serverTimestamp(),
      });
      
      Get.toNamed('/video', arguments: session.sessionId);
    } else {
      Get.defaultDialog(
        title: "Permission Required",
        middleText: "Camera and Microphone permissions are needed to join the session.",
        textConfirm: "Settings",
        onConfirm: () {
            openAppSettings();
            Get.back();
        },
        textCancel: "Cancel",
      );
    }
  }
}
