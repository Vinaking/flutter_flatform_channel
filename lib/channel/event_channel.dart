import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoEventChannel extends StatefulWidget {
  const DemoEventChannel({Key? key}) : super(key: key);

  @override
  State<DemoEventChannel> createState() => _DemoEventChannelState();
}

class _DemoEventChannelState extends State<DemoEventChannel> {
  static const streamFlatform = EventChannel('stream');

  String _message = "stream";

  @override
  void initState() {
    super.initState();

    streamFlatform.receiveBroadcastStream().listen((data) {
      setState(() {
        _message = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Event Channel"),
      ),
      body: Center(
        child: Text(_message, style: const TextStyle(fontSize: 30),),
      ),
    );
  }
}
