import 'package:flutter/material.dart';
import 'package:flutter_platform_channel/pigeon.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  late List<MyMessage?> messages;

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pigeon"),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          MyMessage message = messages[index]!;
          return Column(
            children: [
              Text(message.title),
              Text(message.email)
            ],
          );
        },
      ),
    );
  }

  _getMessages() async {
    final retried = await MessageApi().getMessages("hot@gmail.com");
    setState(() {
      messages = retried;
    });
  }
}
