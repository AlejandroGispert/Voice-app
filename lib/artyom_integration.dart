import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArtyomIntegrationPage extends StatefulWidget {
  @override
  _ArtyomIntegrationPageState createState() => _ArtyomIntegrationPageState();
}

class _ArtyomIntegrationPageState extends State<ArtyomIntegrationPage> {
  late FlutterTts flutterTts; // Marking flutterTts as late

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  Future<void> initTTS() async {
    flutterTts = FlutterTts(); // Now it's safe to assign
    await flutterTts.setLanguage('en-US');
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech Synthesis Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                speakText('Hola, lexy!');
              },
              child: Text('Speak Text'),
            ),
            SizedBox(height: 20),
            Text('Click the button above to hear the text spoken.'),
          ],
        ),
      ),
    );
  }
}
