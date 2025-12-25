import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSoundOn = true; // State for the toggle switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- 1. AVATAR & NAME ---
            Center(
              child: Column(
                children: [
                  // Orange/Yellow Gradient Circle Background
                  Container(
                    padding: const EdgeInsets.all(4), // Border thickness
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.yellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // THIS IS THE FIX: Using backgroundImage makes it fit perfectly
                      backgroundImage: const AssetImage('assets/avatar_boy.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Aarav",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Level 5 Explorer",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // --- 2. STATS ROW (3 Boxes) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("assets/icon_fire.png", "12", "Days Streak"),
                  _buildStatCard("assets/icon_star.png", "635", "Points"),
                  // THIS IS THE FIX: Using your new trophy icon
                  _buildStatCard("assets/icon_trophy.png", "5", "Badges"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. MENU LIST ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuCard(
                    iconPath: "assets/icon_edit.png",
                    title: "Edit Profile",
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  
                  // Special Card for Toggle Switch
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildIconContainer("assets/icon_sound.png"), 
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Text(
                            "Sound & Music",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Switch(
                          value: isSoundOn,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            setState(() {
                              isSoundOn = val;
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  _buildMenuCard(
                    iconPath: "assets/icon_language.png",
                    title: "Language",
                    subtitle: "English / Hindi",
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _buildMenuCard(
                    iconPath: "assets/icon_lock.png",
                    title: "Parent Settings",
                    isOrangeIcon: true, 
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. SIGN OUT BUTTON ---
            TextButton.icon(
              onPressed: () {
                // Sign out logic
              },
              icon: Image.asset("assets/icon_logout.png", width: 20, height: 20),
              label: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- HELPER 1: The Stat Boxes ---
  Widget _buildStatCard(String imgPath, String bigText, String subText) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Image.asset(imgPath, width: 30, height: 30),
          const SizedBox(height: 10),
          Text(
            bigText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            subText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- HELPER 2: The Menu Rows ---
  Widget _buildMenuCard({
    required String iconPath,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isOrangeIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isOrangeIcon ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(iconPath, width: 24, height: 24),
            ),
            const SizedBox(width: 15),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ]
                ],
              ),
            ),
            
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- HELPER 3: Icon Container for Switch Row ---
  Widget _buildIconContainer(String iconPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Image.asset(iconPath, width: 24, height: 24),
    );
  }
}