import 'package:flutter/material.dart';
import 'package:flutter_platform_channel/channel/basic_channel.dart';
import 'package:flutter_platform_channel/channel/event_channel.dart';
import 'package:flutter_platform_channel/channel/method_channel.dart';
import 'package:flutter_platform_channel/pigeon/messaging_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MessagingPage(),
    );
  }
}


/** pigeon command
 *flutter pub run pigeon \
    --input pigeons/messaging.dart \
    --dart_out lib/pigeon.dart \
    --kotlin_out ./android/app/src/main/kotlin/com/example/flutter_platform_channel/Pigeon.kt \
    --java_package "com.example.flutter_platform_channel"

 **/
