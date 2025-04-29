import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gemini_api_flutter/gemini_api_flutter.dart';

void main() {
  runApp(const MyApp());
}

// Root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Hero Story Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sky Hero Story'),
    );
  }
}

// Home Page Widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Home Page State
class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> storyList = []; // Store list of scenes and voices
  bool isLoading = false; // Show loading while fetching

  // Method to generate the story
  Future<void> generateStory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final model = GeminiApiModel(
        model: "gemini-2.0-flash",
        apiKey: "Your-API-Key",
      );

      final response = await model.generateContent(
        [
          Content.multi([
            TextPart('''
Create a captivating story about a "Sky Hero" who protects the skies.
For each scene:
- Describe the scene vividly for visualization (focus on environment, action, emotions).
- Write a voice-over script for the scene (engaging, matching the action).
Respond in structured JSON with an array of objects containing:
- "Scene" (string): Detailed visualization of the scene.
- "Voice" (string): Voice-over text matching the scene.
'''),
          ]),
        ],
        safetySettings: [
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        ],
        generationConfig: GenerationConfig(
          maxOutputTokens: 1000,
          responseMimeType: ResponseMimeType.applicationJson,
          responseSchema: Schema.array(
            items: Schema.object(
              properties: {
                "Scene": Schema.string(description: "Detailed visualization of the scene."),
                "Voice": Schema.string(description: "Voice-over matching the scene action."),
              },
            ),
          ),
        ),
      );

      print("Response text: ${response.text}");

      if (response.text?.isNotEmpty ?? false) {
        try {
          // Parse JSON response
          final decodedJson = jsonDecode(response.text!);

          if (decodedJson is List) {
            setState(() {
              storyList = List<Map<String, String>>.from(decodedJson.map(
                (item) => {
                  "Scene": (item["Scene"] ?? '').toString().replaceAll('\n', ' '),
                  "Voice": (item["Voice"] ?? '').toString().replaceAll('\n', ' '),
                },
              ));
            });
          }
        } catch (e) {
          print("Error decoding JSON: $e");
        }
      }
    } catch (e) {
      print("Error generating story: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : storyList.isEmpty
              ? const Center(child: Text('Press the button to create a story!'))
              : ListView.builder(
                  itemCount: storyList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final story = storyList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          story['Scene'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(story['Voice'] ?? ''),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: generateStory, // Generate story on press
        tooltip: 'Generate Story',
        child: const Icon(Icons.create),
      ),
    );
  }
}
