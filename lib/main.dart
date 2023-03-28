import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:med_app/pages/LargePages/Login_L.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA2TY5ItHAz_1n9-F9gSLWHIy0krF8cjbM",
      appId: "1:335663876125:web:743fb44b688c9ffa81def4",
      messagingSenderId: "335663876125",
      projectId: "medneed-3dfbb",
    ),
  );
  runApp(WebVer());
}

class WebVer extends StatelessWidget {
  WebVer({super.key});
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Lottie.asset("/Vidoes/No_network.zip"),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return GetMaterialApp(
            title: "MedApp",
            debugShowCheckedModeBanner: false,
            home: Login_larger(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        );
      },
    );
  }
}
