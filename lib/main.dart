import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'screens/appointment_screen.dart';
import 'screens/login_screen.dart';
import 'screens/video_screen.dart';
// import 'firebase_options.dart'; // Uncomment if using flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
     
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/appointments', page: () => AppointmentScreen()),
        GetPage(name: '/video', page: () => VideoScreen()),
      ],
    );
  }
}
