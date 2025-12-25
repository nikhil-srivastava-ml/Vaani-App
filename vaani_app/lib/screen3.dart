import 'screen4.dart';
import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  // State variables
  int selectedAge = 5; // Default age selection
  String selectedGender = "Male"; // Default gender
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // We will add the pattern background in the Stack
      body: Stack(
        children: [
          // 1. BACKGROUND PATTERN (Reused)
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset('assets/background_pattern.png', repeat: ImageRepeat.repeat, scale: 0.8),
            ),
          ),

          // 2. ORANGE HEADER CURVE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: ClipPath(
              clipper: SimpleCurveClipper(),
              child: Container(color: const Color(0xFFFF9800)),
            ),
          ),

          // 3. MAIN CONTENT (Scrollable)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Title
                  const Center(
                    child: Text(
                      "Signup with your details",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // FORM FIELDS
                  _buildLabel("Name"),
                  _buildTextField("Amol Basu"),

                  _buildLabel("Email"),
                  _buildTextField("vimalbasu007@gmail.com"),

                  _buildLabel("Mobile Number"),
                  _buildTextField("01 8745 6548"),

                  _buildLabel("Child's Name"),
                  _buildTextField("Vimal Basu"),

                  const SizedBox(height: 15),

                  // AGE & GENDER ROW
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AGE SELECTOR
                      // AGE SELECTOR (Now Scrollable!)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Child's Age (Years)"),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              // Use a fixed height for the scrollable area
                              height: 70, 
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 16, // For ages 1 to 16
                                itemBuilder: (context, index) {
                                  int age = index + 1; // Age starts at 1
                                  bool isSelected = selectedAge == age;
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedAge = age),
                                    child: Container(
                                      // Add padding between circles
                                      margin: const EdgeInsets.symmetric(horizontal: 5), 
                                      width: 45, // Slightly larger for better touch
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.orange : Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "$age",
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, // Larger font
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      // GENDER SELECTOR
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Child's Gender"),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // BOY ICON
                                  GestureDetector(
                                    onTap: () => setState(() => selectedGender = "Male"),
                                    child: _buildGenderIcon("assets/icon_boy.png", selectedGender == "Male"),
                                  ),
                                  // GIRL ICON
                                  GestureDetector(
                                    onTap: () => setState(() => selectedGender = "Female"),
                                    child: _buildGenderIcon("assets/icon_girl.png", selectedGender == "Female"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _buildLabel("New Password"),
                  _buildPasswordField(isPasswordVisible, (val) => setState(() => isPasswordVisible = val)),

                  _buildLabel("Confirm Password"),
                  _buildPasswordField(isConfirmPasswordVisible, (val) => setState(() => isConfirmPasswordVisible = val)),

                  const SizedBox(height: 30),

                  // SIGNUP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Signup Clicked!");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen4()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Signup", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5, top: 10),
      child: Text(text, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isVisible, Function(bool) onToggle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange),
      ),
      child: TextField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: "●●●●●●●●",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
            onPressed: () => onToggle(!isVisible),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderIcon(String assetPath, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      // Uses your exported icons!
      child: Image.asset(assetPath, width: 24, height: 24, color: isSelected ? Colors.white : Colors.grey),
    );
  }
}

// Simple top curve
class SimpleCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height + 20, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}