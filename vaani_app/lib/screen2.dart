
import 'screen3.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int selectedIndex = -1;

  final List<Map<String, dynamic>> levels = [
    {
      "title": "Preschool",
      "subtitle": "Ages 4 and under",
      "color": const Color(0xFFFFEBEE),
      "icon": "assets/icon_preschool.png"
    },
    {
      "title": "Younger",
      "subtitle": "Ages 4-6",
      "color": const Color(0xFFE3F2FD),
      "icon": "assets/icon_younger.png"
    },
    {
      "title": "Older",
      "subtitle": "Ages 7-12",
      "color": const Color(0xFFE8F5E9),
      "icon": "assets/icon_older.png"
    },
    {
      "title": "Teenager",
      "subtitle": "Ages 12+",
      "color": const Color(0xFFF3E5F5),
      "icon": "assets/icon_teenager.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ORANGE HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Choose Your Level",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We will customize your exercises based on your age",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          
          // CARD GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: levels[index]['color'],
                        borderRadius: BorderRadius.circular(20),
                        border: selectedIndex == index 
                          ? Border.all(color: Colors.orange, width: 3) 
                          : Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(levels[index]['icon'], height: 60),
                          const SizedBox(height: 15),
                          Text(levels[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(levels[index]['subtitle'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // BUTTON
          // 3. CONTINUE BUTTON (Updated to work!)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedIndex == -1) {
                    // If nothing is selected, do nothing
                    return; 
                  }
                  // If something IS selected, print it!
                  print("You selected: ${levels[selectedIndex]['title']}");
                  
                  // TODO: Navigate to the next screen (Screen 3) here later
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen3()));
                },
                style: ElevatedButton.styleFrom(
                  // COLOR LOGIC: If nothing selected (-1) -> Grey. Otherwise -> Orange.
                  backgroundColor: selectedIndex == -1 ? const Color(0xFFCFD8DC) : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    // TEXT COLOR: Grey if disabled, White if enabled
                    color: selectedIndex == -1 ? Colors.black54 : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}