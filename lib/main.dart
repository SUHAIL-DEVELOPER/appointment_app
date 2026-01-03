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
  
  // Initialize Firebase using the default options if available, 
  // otherwise relies on manual configuration (google-services.json etc)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  // Initialize Auth Controller which handles redirection
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
      // AuthController logic in ever() listener decides initial route,
      // but we provide a default here or just showing loading until redirect happens.
      // We'll set home to a Center(CircularProgressIndicator()) while AuthController decides.
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/appointments', page: () => AppointmentScreen()),
        GetPage(name: '/video', page: () => VideoScreen()),
      ],
    );
  }
}
