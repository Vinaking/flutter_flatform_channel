import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoBasicChannel extends StatefulWidget {
  const DemoBasicChannel({Key? key}) : super(key: key);

  @override
  State<DemoBasicChannel> createState() => _DemoBasicChannelState();
}

class _DemoBasicChannelState extends State<DemoBasicChannel> {
  static const String _stringCodecChannel = 'StringCodec';
  static const String _jSONMessageCodecChannel = 'JSONMessageCodec';
  static const String _binaryCodecChannel = 'BinaryCodec';
  static const String _standardMessageCodecChannel = 'StandardMessageCodec';

  static const BasicMessageChannel<String> stringPlatform = BasicMessageChannel(_stringCodecChannel, StringCodec());
  static const BasicMessageChannel<dynamic> jsonPlatform = BasicMessageChannel(_jSONMessageCodecChannel, JSONMessageCodec());
  static const BasicMessageChannel<ByteData> binaryPlatform = BasicMessageChannel(_binaryCodecChannel, BinaryCodec());
  static const BasicMessageChannel<dynamic> standardPlatform = BasicMessageChannel(_standardMessageCodecChannel, StandardMessageCodec());

  String _messageString = 'empty';
  String _messageJson = 'empty';
  String _messageBinary = 'empty';
  String _messageStandard = 'empty';

  Future<String> _handleStringPlatform(String? response) async {
    setState(() {
      _messageString = response ?? "";
    });
    return "";
  }

  Future<dynamic> _handleJsonPlatform(dynamic response) async {
    setState(() {
      _messageJson = response.toString();
    });
  }

  _handleBinaryPlatform() async {
    if (Platform.isAndroid) {
      final WriteBuffer buffer = WriteBuffer()
        ..putFloat64(1.12345);
      final ByteData message = buffer.done();

      ByteData? result = await binaryPlatform.send(message);
      setState(() {
        _messageBinary = 'Received ${result!.getFloat64(0)}';
      });
    }
    if (Platform.isIOS) {
      final tmp = utf8.encoder.convert("1.12345".toString());
      ByteData? result =
      await binaryPlatform.send(tmp.buffer.asByteData());

      final buffer = result!.buffer;
      var list = buffer.asUint8List(
          result.offsetInBytes, result.lengthInBytes);

      setState(() {
        _messageBinary = utf8.decode(list);
      });
    }

  }

  _handleStandardPlatform() async {
    var list = await standardPlatform.send([1, 2, 3, 4, 5]);
    setState(() {
      _messageStandard = list.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stringPlatform.setMessageHandler((message) => _handleStringPlatform(message));
    jsonPlatform.setMessageHandler((message) => _handleJsonPlatform(message));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Message Channel"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_messageString),
            ElevatedButton.icon(
                onPressed: (){
                  stringPlatform.send("Tom");
                },
                icon: const Icon(Icons.add),
                label: const Text("String Channel")
            ),
            Text(_messageJson),
            ElevatedButton.icon(
                onPressed: (){
                  jsonPlatform.send("Vinaking");
                },
                icon: const Icon(Icons.add),
                label: const Text("Json Channel")
            ),
            Text(_messageBinary),
            ElevatedButton.icon(
                onPressed: (){
                  _handleBinaryPlatform();
                },
                icon: const Icon(Icons.add),
                label: const Text("Binary Channel")
            ),
            Text(_messageStandard),
            ElevatedButton.icon(
                onPressed: (){
                  _handleStandardPlatform();
                },
                icon: const Icon(Icons.add),
                label: const Text("Standard Channel")
            ),
          ],
        ),
      ),
    );

  }
}
