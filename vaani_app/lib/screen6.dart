import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
// 1. IMPORT OUR NEW TOOLS
import 'audio_manager.dart';
import 'api_service.dart';
import 'data.dart'; 

class Screen6 extends StatefulWidget {
  final String categoryType; 

  const Screen6({super.key, required this.categoryType});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  int currentLevelIndex = 0;
  bool isLoading = true;
  
  // VOICE TOOLS
  final FlutterTts _flutterTts = FlutterTts();
  
  // 2. NEW AUDIO RECORDING TOOLS
  final AudioManager _audioManager = AudioManager();
  bool _isRecording = false;
  bool _isAnalyzing = false; // To show a loading spinner while Python thinks

  @override
  void initState() {
    super.initState();
    // UNCOMMENT TO RESET PROGRESS FOR TESTING:
    // SharedPreferences.getInstance().then((prefs) => prefs.clear()); 

    _loadProgress();
    _initTts();
    _audioManager.init(); // Initialize Recorder
  }

  @override
  void dispose() {
    _audioManager.dispose(); // Clean up Recorder
    super.dispose();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  // --- 1. SPEAK FUNCTION (Text-to-Speech) ---
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  // --- 2. RECORDING LOGIC (The "Brain" Connection) ---
  Future<void> _toggleRecording(String targetWord) async {
    if (_isRecording) {
      // --- STOP RECORDING & SEND TO PYTHON ---
      String? filePath = await _audioManager.stopRecording();
      setState(() {
        _isRecording = false;
        _isAnalyzing = true; // Show loading spinner
      });

      if (filePath != null) {
        print("🎤 Audio saved at: $filePath");
        
        // SEND TO PYTHON API
        // We pass 'targetWord' which is already passed into _toggleRecording
        var result = await ApiService.sendAudio(filePath, targetWord);

        setState(() => _isAnalyzing = false); // Stop loading

        if (result != null) {
          // WE GOT A RESPONSE FROM PYTHON!
          int score = result['pronunciation_score'] ?? 0;
          String feedback = result['feedback'] ?? "Keep trying!";
          String detected = result['text_detected'] ?? "";

          // Show the Result Box
          _showResultDialog(score, detected, feedback, targetWord);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Error connecting to Server")),
           );
        }
      }
    } else {
      // --- START RECORDING ---
      await _audioManager.startRecording();
      setState(() => _isRecording = true);
    }
  }

  // --- 3. RESULT DIALOG (Shows Python Score) ---
  void _showResultDialog(int score, String detectedWord, String feedback, String targetWord) {
    bool isPass = score > 70; // Pass if score is above 70%

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isPass ? const Color(0xFF4CAF50) : Colors.redAccent, // Green if pass, Red if fail
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 300, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isPass ? "AWESOME!" : "TRY AGAIN", 
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Text(
                    "$score%", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isPass ? Colors.green : Colors.red)
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "You said: \"$detectedWord\"",
                  style: const TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Text(
                  feedback, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontSize: 14, color: Colors.white)
                ),
                const Spacer(),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close Box
                    if (isPass) {
                       _levelUp(); // Only go to next level if they pass!
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: isPass ? Colors.green : Colors.red,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(isPass ? "Next Level" : "Retry", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // --- DATA LOADING LOGIC ---
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String key = "${widget.categoryType}_Level"; 
    setState(() {
      currentLevelIndex = prefs.getInt(key) ?? 0;
      isLoading = false;
    });
  }

  Future<void> _levelUp() async {
    final prefs = await SharedPreferences.getInstance();
    String key = "${widget.categoryType}_Level";
    setState(() {
      currentLevelIndex++; 
    });
    await prefs.setInt(key, currentLevelIndex);
  }

  Map<String, String> getCurrentContent() {
    List<Map<String, String>> sourceList;
    
    // Pick the right list from data.dart
    if (widget.categoryType == "Alphabet") sourceList = alphabetData;
    else if (widget.categoryType == "Words") sourceList = wordData;
    else if (widget.categoryType == "Phonetics") sourceList = phoneticData;
    else sourceList = sentenceData;

    // Check if user finished all levels
    if (currentLevelIndex >= sourceList.length) {
      return {"text": "DONE!", "image": "assets/img_dog_face.png", "sub": "Course Complete"};
    }
    return sourceList[currentLevelIndex];
  }

 @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final data = getCurrentContent();
    bool isDone = data['text'] == "DONE!";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      
      // TOP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () => Navigator.pop(context)
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
          child: Text("LEVEL ${currentLevelIndex + 1}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),

      // MAIN CONTENT (Dog, Mic, etc.)
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Try Speaking", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 30),

          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: isDone ? const Center(child: Text("All Levels Completed!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))) : 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IMAGE
                      SizedBox(
                        height: 80, 
                        width: 80, 
                        child: Image.asset(
                          data['image']!, 
                          fit: BoxFit.contain, 
                          errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 50, color: Colors.orange)
                        )
                      ),
                      const SizedBox(width: 20),
                      
                      // AUTO-FIT TEXT BOX
                      Container(
                        height: 120, 
                        width: 180, 
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown, 
                              child: Text(
                                data['text']!, 
                                textAlign: TextAlign.center, 
                                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blue)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(data['sub']!, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  
                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _speak(data['text']!), 
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: Row(children: const [Icon(Icons.volume_up, color: Colors.orange), SizedBox(width: 5), Text("Sound")]),
                        ),
                      ),
                        Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                        child: Row(children: const [Icon(Icons.help_outline, color: Colors.orange), SizedBox(width: 5), Text("Tip")]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- THE SMART MIC BUTTON ---
                  GestureDetector(
                    onTap: () => _toggleRecording(data['text']!), // Call our new function
                    child: Container(
                      height: 80, width: 80,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : Colors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
                        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 8),
                      ),
                      child: _isAnalyzing 
                        ? const CircularProgressIndicator(color: Colors.white) // Show spinner if sending to Python
                        : Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(_isRecording ? "Stop" : "Tap to Speak", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // BOTTOM BAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, 
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 30), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded, size: 30), label: "Heart"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded, size: 30), label: "Trophy"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 30), label: "Profile"),
        ],
      ),
    );
  }
}