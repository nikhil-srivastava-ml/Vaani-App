import 'package:flutter/material.dart';

class Screen8 extends StatelessWidget {
  const Screen8({super.key});

  @override
  Widget build(BuildContext context) {
    // No Scaffold here, Screen 5 handles the main structure
    return Container(
      color: const Color(0xFFFDFDFD), // Slightly off-white background
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "What are you looking for...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: Icon(Icons.mic, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. HEADER: PARENT ZONE
              const Text("Parent Zone", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent Activities", style: TextStyle(color: Colors.grey)),
                  Text("View all", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 15),

              // 3. RECENT ACTIVITY CARDS (Horizontal)
              Row(
                children: [
                  _buildActivityCard(
                    title: "Word Learning",
                    time: "12 mins ago",
                    color: const Color(0xFFE91E63), // Pink
                    imagePath: "assets/parent_word_learning.png", // Ensure you added this image!
                  ),
                  const SizedBox(width: 15),
                  _buildActivityCard(
                    title: "Alphabet Sounds",
                    time: "40 mins ago",
                    color: const Color(0xFFFFC107), // Amber/Yellow
                    imagePath: "assets/parent_alphabet.png", // Ensure you added this image!
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 4. KID'S ACTIVITY (Circles)
              const Text("Kid's Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircleProgress("अ", 0.75, Colors.orange),
                  _buildCircleProgress("त", 0.62, Colors.orange.shade300),
                  _buildCircleProgress("ह", 0.86, Colors.deepOrange),
                ],
              ),

              const SizedBox(height: 20),

              // 5. STATS BOX (Minutes / Days)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("48", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text("Minutes", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text("Average time spent per\nday", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 50, child: VerticalDivider(thickness: 1, color: Colors.blue)), // Divider
                    Column(
                      children: [
                        Text("12", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text("Days", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text("Average days spent per\nmonth", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 6. SKILLS ACQUIRED
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Skills Acquired", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View all", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 15),
              _buildSkillBar("Phonetics", 0.4, Colors.redAccent, Icons.psychology),
              _buildSkillBar("Language", 0.6, Colors.orange, Icons.menu_book),
              _buildSkillBar("Listening", 0.5, Colors.blue, Icons.hearing),
              
              const SizedBox(height: 80), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildActivityCard({required String title, required String time, required Color color, required String imagePath}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image placeholder (Use actual Image.asset when you have them)
                Image.asset(imagePath, height: 50, errorBuilder: (c,o,s) => const Icon(Icons.image, size: 50, color: Colors.white)),
                const SizedBox(height: 10),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCircleProgress(String char, double percent, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70, height: 70,
              child: CircularProgressIndicator(value: percent, strokeWidth: 6, color: color, backgroundColor: Colors.grey.shade200),
            ),
            Text(char, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 5),
        Text("${(percent * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSkillBar(String title, double percent, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("${(percent * 100).toInt()}%", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: percent, color: color, backgroundColor: Colors.grey.shade100, minHeight: 6, borderRadius: BorderRadius.circular(5)),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Beginner", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text("Proficient", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}