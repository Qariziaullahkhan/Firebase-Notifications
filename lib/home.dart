import 'dart:convert';

import 'package:firebase_notifications/Notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {

  NotificationServices notificationServices = NotificationServices();
  
  @override
  void initState() {

    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.Firebaseinit(context);
    notificationServices.InteractMessage(context);
    notificationServices.IsTokenReferes();
    notificationServices.getDeviceToken().then((value){
    if(kDebugMode){
 print("Device Token");
    print(value);
    }
   
  });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text("Flutter Notifications"),
        
      ),
      body: Center(
        child: TextButton(onPressed: (){
        
          NotificationServices.getDeviceToken.then(()async{
        
            var data = {
              'to' : values.toString(),
              'notification' : {
                'title' : 'Asif' ,
                'body' : 'Subscribe to my channel' ,
                "sound": "jetsons_doorbell.mp3"
            },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'type' : 'msj' ,
                'id' : 'Asif Taj'
              }
            };
        await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode(data) ,
          'Content-Type': 'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAp9pXDFM:APA91bGhBeMCUABE2PXjl9UqodAZ2WdV_UI6PoiwdCzYaT8KeZmBKZszc01CD1GgN0OAJ1w3sNw9IVISyKhrrxQLASHizenGJUr2hjzoPjbjFu0HAx1CTk0l8Ut95ZENAQyRKm6hrltV'
        
        ).then((value){
              if (kDebugMode) {
                print(value.body.toString());
              }
            }).onError((error, stackTrace){
              if (kDebugMode) {
                print(error);
              }
            });
        
        
          });
        
        }, child:  Text("Sent Notifications"),
        ),
      ),
    );
  }
}