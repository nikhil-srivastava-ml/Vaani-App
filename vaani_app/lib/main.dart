import 'screen2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VaaniApp());
}

class VaaniApp extends StatelessWidget {
  const VaaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vaani',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // State to track if Child or Parent is selected
  bool isChildSelected = true;

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND PATTERN (Fixed Visibility)
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // CHANGED: More visible now
              child: Image.asset(
                'assets/background_pattern.png',
                repeat: ImageRepeat.repeat,
                scale: 0.8, 
              ),
            ),
          ),

          // 2. ORANGE HEADER (The Wave)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.60, 
            child: ClipPath(
              clipper: OrganicWaveClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF9800), // Vibrant Orange
                      Color(0xFFF57C00), // Darker Orange
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. DECORATIVE BUBBLES
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            top: 120,
            right: -30,
            child: CircleAvatar(radius: 50, backgroundColor: Colors.black.withOpacity(0.05)),
          ),

          // 4. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10), 

                // --- FIX: BIGGER LOGO ---
                Center(
                  child: Image.asset(
                    'assets/app_logo_white.png',
                    width: screenWidth * 0.8, // Force it to be 60% of screen width
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 10),

                // ILLUSTRATION
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/welcome_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // "Logging in as" SECTION
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const Text(
                        "Logging in as",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ROLE BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRoleButton(
                            label: "Child",
                            letter: "S",
                            color: const Color(0xFFFF9800),
                            isSelected: isChildSelected,
                            onTap: () => setState(() => isChildSelected = true),
                          ),
                          const SizedBox(width: 40),
                          _buildRoleButton(
                            label: "Parents",
                            letter: "P",
                            color: Colors.grey,
                            isSelected: !isChildSelected,
                            onTap: () => setState(() => isChildSelected = false),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // PLAY BUTTON
                      GestureDetector(
                        onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => const Screen2()),
                          );
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 45),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Buttons
  Widget _buildRoleButton({
    required String label,
    required String letter,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade400,
              boxShadow: isSelected 
                ? [BoxShadow(color: const Color(0xFFFF9800).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))] 
                : [],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isSelected ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the Wave
class OrganicWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80); 
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}