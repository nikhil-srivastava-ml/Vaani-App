import 'screen5.dart';
import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. ORANGE HEADER (Reusing the style)
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
                // Back Button
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
                // Title
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Subtitle
                const Text(
                  "Complete these quick checks to build your personal plan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // 2. THE LIST OF TASKS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildTaskCard(
                  title: "Medical History",
                  color: const Color(0xFFE91E63), // Pink
                  iconPath: "assets/icon_medical.png",
                  context: context,
                ),
                const SizedBox(height: 15),
                _buildTaskCard(
                  title: "Hearing Test",
                  color: const Color(0xFF00BCD4), // Cyan
                  iconPath: "assets/icon_hearing.png",
                  context: context,
                ),
                const SizedBox(height: 15),
                _buildTaskCard(
                  title: "Oral Photo Analysis",
                  color: const Color(0xFF9C27B0), // Purple
                  iconPath: "assets/icon_oral.png",
                  context: context,
                ),
                const SizedBox(height: 15),
                _buildTaskCard(
                  title: "Speech Analysis",
                  color: const Color(0xFF8BC34A), // Green
                  iconPath: "assets/icon_speech.png",
                  context: context,
                ),
              ],
            ),
          ),

          // 3. CONTINUE BUTTON
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                   print("Onboarding Complete!");
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  Screen5()));
                   // Navigate to Dashboard/Home later
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // --- HELPER WIDGET FOR THE CARDS ---
  Widget _buildTaskCard({
    required String title,
    required Color color,
    required String iconPath,
    required BuildContext context,
  }) {
    return Container(
      height: 80, // Fixed height for consistency
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material( // Material added for ripple effect on tap
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            print("Clicked on $title");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // ICON BOX (Light square background)
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(iconPath, color: Colors.white), 
                  // If you don't have images yet, replace line above with:
                  // child: Icon(Icons.star, color: Colors.white),
                ),
                
                const SizedBox(width: 15),
                
                // TITLE
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // PLAY BUTTON (Yellow Circle)
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107), // Amber/Yellow
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}