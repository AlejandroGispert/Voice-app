import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Ensure FlutterTts is imported
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Ensure SpeechToText is imported
// import 'artyom_integration.dart'; // Adjust the import path as necessary
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Voice App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  String lastRecognizedSentence = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                List<String> sentences = [
                  'Hello',
                  'How are you?',
                  'What is your name?',
                  'Are you good?',
                  "What day is today?",
                  "What date is today?"
                      "What time is it?",
                ];
                for (String sentence in sentences) {
                  await speech.listen(localeId: 'en_US');
                  // Listen for a short period or until the user stops speaking
                  await Future.delayed(
                      Duration(seconds: 2)); // Adjust delay as needed
                  print(
                      'Recognized words: $sentence'); // Process recognized words
                  lastRecognizedSentence =
                      sentence; // Update the last recognized sentence
                  await speech.stop();
                }
              },
              child: BigCard(pair: pair),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                speakText('Hello');
                speakText('Lexy');
              },
              child: Text('Speak Text'),
            ),
            SizedBox(height: 20),
            Text(
                'Recognized Text: $lastRecognizedSentence'), // Display the last processed sentence
            ElevatedButton(
              onPressed: () async {
                await speech.initialize();

                await speech.listen(localeId: 'en_US');
                // Listen for a short period or until the user stops speaking
                await Future.delayed(
                    Duration(seconds: 2)); // Adjust delay as needed
                print(
                    'Recognized words: $lastRecognizedSentence'); // Process recognized words
                await speech.stop();
              },
              child: Text('Listen'),
            ),
          ],
        ),
      ),
    );
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontSize: 24, // Example font size
      fontWeight: FontWeight.bold, // Example font weight
      color: theme.colorScheme.onPrimary, // Using theme color for contrast
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Card(
        color: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            pair.asLowerCase,
            style: textStyle,
            textAlign: TextAlign.center,
            semanticsLabel: "${pair.first} ${pair.second}",
          ),
        ),
      ),
    );
  }
}
