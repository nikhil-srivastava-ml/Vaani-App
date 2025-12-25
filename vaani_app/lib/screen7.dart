import 'package:flutter/material.dart';

class Screen7 extends StatefulWidget {
  const Screen7({super.key});

  @override
  State<Screen7> createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
  // Toggle state: 0 = Badges, 1 = Gifts
  int _selectedToggleIndex = 0; 

  // Badge Data
  final List<Map<String, dynamic>> badges = [
    {"title": "Practice Perfect", "subtitle": "Hold a 7 day streak", "icon": "🥇", "color": const Color(0xFFFFF9C4)}, // Light Yellow
    {"title": "Achiever", "subtitle": "Practice more than 10 sounds", "icon": "🎖️", "color": const Color(0xFFF8BBD0)}, // Light Pink
    {"title": "Diligence Day", "subtitle": "Attain your 1st Gift", "icon": "👶", "color": const Color(0xFFC8E6C9)}, // Light Green
    {"title": "Mastery", "subtitle": "Attain 50%+ in 10 sounds", "icon": "⭐", "color": const Color(0xFFC8E6C9)}, 
    {"title": "Graduate", "subtitle": "Practice 50+ sounds", "icon": "🎓", "color": const Color(0xFFFFF9C4)}, 
    {"title": "Regular kid", "subtitle": "Hold 14+ day streak", "icon": "😊", "color": const Color(0xFFC8E6C9)},
    {"title": "Star Performer", "subtitle": "Complete 100 activities", "icon": "🌟", "color": const Color(0xFFFFF9C4)},
    {"title": "Champion", "subtitle": "Achieve 90%+ accuracy", "icon": "🏆", "color": const Color(0xFFC8E6C9)},
  ];

  @override
  Widget build(BuildContext context) {
    // NOTE: We use Container/Column here, NOT Scaffold.
    // Screen 5 handles the AppBar and BottomBar.
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              
              // 1. TOGGLE BUTTON (Badges | Gifts)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleButton("Badges", 0),
                    _buildToggleButton("Gifts", 1),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. PROGRESS BAR
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.635, // 635 / 1000
                            backgroundColor: Colors.grey[200],
                            color: Colors.green,
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text("635 / 1000", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Gift Icon Box
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent, // Matches the screenshot gradient roughly
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                         BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 5, offset: const Offset(0,3))
                      ]
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 3. BADGES GRID
              GridView.builder(
                shrinkWrap: true, // IMPORTANT: Allows Grid to sit inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Disables Grid's own scrolling
                itemCount: badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  childAspectRatio: 0.8, // Adjusts height of cards
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  return _buildBadgeCard(badges[index]);
                },
              ),
              
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER: TOGGLE BUTTON ---
  Widget _buildToggleButton(String text, int index) {
    bool isSelected = _selectedToggleIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedToggleIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- HELPER: BADGE CARD ---
  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    return Container(
      decoration: BoxDecoration(
        color: badge['color'],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon (Using Text as placeholder for Emoji icons, replace with Image.asset if needed)
          Text(badge['icon'], style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          // Title
          Text(
            badge['title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              badge['subtitle'],
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}