import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications/home.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyBli0vbQTAl_dFF1Fuw0ozVdy1gudCM5vs",
     appId: "1:121782748654:android:93bc2424514b947a5bfaff", 
     messagingSenderId: "121782748654",
      projectId:  "fir-notifications-da9c5",
      storageBucket: "fir-notifications-da9c5.appspot.com"));
      FirebaseMessaging.onBackgroundMessage(_FirebasemessegingbackgoundHandler);
  runApp(const MyApp());
}
@pragma("vm:entry-point")
Future<void>_FirebasemessegingbackgoundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
    print(message.notification!.body.toString());
      print(message.data.toString());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScree(),
    );
  }
}

