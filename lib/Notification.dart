import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications/message_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

FirebaseMessaging messaging = FirebaseMessaging.instance;

void requestNotificationPermission()async{
NotificationSettings settings = await messaging.requestPermission(
alert: true,
announcement: true,
badge: true,
carPlay: true,
provisional: true,
criticalAlert: true,
sound: true,
);
if(settings.authorizationStatus == AuthorizationStatus.authorized){
  print("user Granted Permission");
}else if(settings.authorizationStatus == AuthorizationStatus.provisional){
print("user Granted Provisional Permission");
}
else{
print("user Denied Permission ");
}
}
void initLocalNotification(BuildContext context, RemoteMessage message)async{
var androidInitializationSettings =const  AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosinitilalizationSetting  = const DarwinInitializationSettings();

    var initilalizationSetting = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosinitilalizationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(initilalizationSetting,
    onDidReceiveBackgroundNotificationResponse: (payload){
   Handlemessage(context, message);
    }
    );
    
}

void Firebaseinit(BuildContext context){
  FirebaseMessaging.onMessage.listen((message){

RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;

    if(kDebugMode){

        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
    //    print(message.notification!.title.toString());
    // print(message.notification!.body.toString());
    // print(message.data["type"]);
    // print(message.data["id"]);

    }
      if(Platform.isIOS){
        forgroundMessage();
      }
    if(Platform.isAndroid){
initLocalNotification(context, message);
        showNotification(message);
    }
    else{
      showNotification(message);
    }
    

   
  });
}     

Future<void>showNotification(RemoteMessage message)async{

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    
    Random.secure().nextInt(10000).toString(),
    "High Performance",
    importance: Importance.max,
    
    
    
    );
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    
    channel.id.toString(), 
    channel.name.toString(),
    channelDescription: "your description is ready",
    importance: Importance.high,
    priority: Priority.high,
    ticker: "ticker",
    
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
presentAlert: true,
presentBadge: true,
presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
       iOS: darwinNotificationDetails
    );
  Future.delayed(Duration.zero,(){
    _flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title.toString(), 
    message.notification!.body.toString(),
     notificationDetails);

  }
  
  
  );

}
      Future<String>getDeviceToken()async{

        String? token = await messaging.getToken();
        return token!;
               
}
// when the app is terminited
Future<void>InteractMessage(BuildContext context)async{
RemoteMessage? initilaMessage = await FirebaseMessaging.instance.getInitialMessage();
if(initilaMessage!= null){
  Handlemessage(context, initilaMessage);

  // when app is background
  FirebaseMessaging.onMessageOpenedApp.listen((event){
    Handlemessage(context, event);

  });
}
}

void Handlemessage(BuildContext context,RemoteMessage message){
  if(message.data["type"] == "message"){

    Navigator.push(context, 
    MaterialPageRoute(builder: (context) =>  MessageScreen
    (id: message.data["id"],)));
  }

}

      void IsTokenReferes()async{
        messaging.onTokenRefresh.listen((event){
               event.toString();
               print("Referesh");
       } );

               
}
 Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

}


