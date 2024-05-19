import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  String lastRecognizedSentence = '';
  bool isListening = false;

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
              onTap: () => _listenAndRespond(),
              child: BigCard(pair: pair),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _speakText('Hello');
                _speakText('Lexy');
              },
              child: Text('Speak Text'),
            ),
            SizedBox(height: 20),
            Text('Recognized Text: $lastRecognizedSentence'),
            ElevatedButton(
              onPressed: _listen,
              child: Text(isListening ? 'Listening...' : 'Listen'),
            ),
          ],
        ),
      ),
    );
  }

  void _speakText(String text) async {
    await flutterTts.speak(text);
  }

  void _listen() async {
    if (!isListening) {
      bool available = await speech.initialize();
      if (available) {
        setState(() => isListening = true);
        speech.listen(onResult: (result) {
          setState(() {
            lastRecognizedSentence = result.recognizedWords;
            isListening = false;
          });
          _processCommand(lastRecognizedSentence);
        });
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  void _listenAndRespond() async {
    if (!isListening) {
      bool available = await speech.initialize();
      if (available) {
        setState(() => isListening = true);
        speech.listen(onResult: (result) {
          setState(() {
            lastRecognizedSentence = result.recognizedWords;
            isListening = false;
          });
          _processCommand(lastRecognizedSentence);
        });
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  void _processCommand(String command) {
    if (command.toLowerCase().contains("what day is today")) {
      String day = DateFormat('EEEE').format(DateTime.now());
      _speakText("Today is $day");
    }
    // Add more command processing as needed
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
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onPrimary,
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
