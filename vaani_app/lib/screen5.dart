 // Ensure this file exists in lib/
import 'dart:math';
import 'package:flutter/material.dart';
import 'screen9.dart'; // Profile Screen (Ensure class is named ProfileScreen inside screen9.dart)
import 'screen6.dart'; // Detail Screen
import 'screen7.dart'; // Achievements
import 'screen8.dart'; // Parent Zone

class Screen5 extends StatefulWidget {
  const Screen5({super.key});

  @override
  State<Screen5> createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  // --- COMBINED STATE VARIABLES ---
  


  // 2. Carousel Logic Variables
  late PageController _pageController;
  int _currentPage = 1;
  int _selectedIndex = 0; // Bottom Navigation Index

  final List<Map<String, dynamic>> categories = [
    {"title": "Alphabet", "image": "assets/cat_alphabet.png", "color": Colors.orange},
    {"title": "Phonetics", "image": "assets/cat_phonetic.png", "color": Colors.blue},
    {"title": "Words", "image": "assets/cat_word.png", "color": Colors.green},
    {"title": "Sentences", "image": "assets/cat_sentence.png", "color": Colors.purple},
  ];

  // --- MERGED INIT STATE (Runs once when screen loads) ---
  @override
  void initState() {
    super.initState();
    
    
    // 2. Initialize Carousel Controller
    _pageController = PageController(viewportFraction: 0.6, initialPage: 1);
  }

  // --- MERGED DISPOSE (Runs when screen closes) ---
  @override
  void dispose() {
    
    
    // 2. Clean up Carousel
    _pageController.dispose();
    
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // DYNAMIC APP BAR logic
      appBar: _getAppBar(),

      // BODY CONTENT logic
      body: _buildBody(),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
           setState(() {
             _selectedIndex = index;
           });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: ""), 
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

 

  // --- BODY SWITCHER ---
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(); 
      case 1:
        return const Screen7(); // Achievements
      case 2:
        return const Screen8(); // Parent Zone
      case 3:
        return const ProfileScreen(); // Profile Screen
      default:
        return _buildHomeContent();
    }
  }

  // --- APP BAR SWITCHER ---
  PreferredSizeWidget? _getAppBar() {
    if (_selectedIndex == 0) {
      return _buildHomeAppBar();
    } else if (_selectedIndex == 1) {
      return AppBar(
        title: const Text("Achievements", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      );
    } else if (_selectedIndex == 2) {
      return null; // Parent Zone has internal header
    } else {
      return null; // Profile screen usually has its own AppBar
    }
  }

  // --- HOME APP BAR ---
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Icon(Icons.menu, color: Colors.black),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        )
      ],
      title: Column(
        children: [
          const Text("My Progress", style: TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  // --- HOME CONTENT (Map + Carousel) ---
  Widget _buildHomeContent() {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // MAP WINDOW
            Center(
              child: Container(
                height: 400, 
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)], 
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SingleChildScrollView(
                      reverse: true, 
                      child: SizedBox(
                        height: 2000, 
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: WindingPathPainter(levels: 25),
                              ),
                            ),
                            ...List.generate(25, (index) {
                              int levelNumber = index + 1;
                              double topPosition = 2000.0 - (levelNumber * 80.0) - 50; 
                              double leftPosition = 150 + 80 * sin(levelNumber * 0.8); 
                              return Positioned(
                                top: topPosition,
                                left: leftPosition - 25, 
                                child: _buildMapNode(
                                  label: "$levelNumber", 
                                  isLocked: levelNumber > 1, 
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // CATEGORIES TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 20),

            // CAROUSEL
            SizedBox(
              height: 300, 
              child: PageView.builder(
                controller: _pageController,
                itemCount: categories.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildCarouselItem(index);
                },
              ),
            ),
            
            // Extra space at bottom so Mic button doesn't cover content
            const SizedBox(height: 100),
          ],
        ),
      );
  }

  Widget _buildCarouselItem(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        } else {
          value = index == _currentPage ? 1.0 : 0.7;
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (_currentPage != index) {
            _pageController.animateToPage(
              index, 
              duration: const Duration(milliseconds: 500), 
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Screen6(categoryType: categories[index]['title'])
              )
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            border: _currentPage == index ? Border.all(color: Colors.orange, width: 2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(categories[index]['image'], fit: BoxFit.contain),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  categories[index]['title'],
                  style: TextStyle(fontSize: _currentPage == index ? 20 : 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapNode({required String label, required bool isLocked}) {
    return GestureDetector(
      onTap: () { print("Clicked Level $label"); },
      child: Column(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: isLocked ? Colors.white.withOpacity(0.5) : const Color(0xFFFFC107),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))]
            ),
            child: Icon(isLocked ? Icons.lock : Icons.play_arrow, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
        ],
      ),
    );
  }
}

class WindingPathPainter extends CustomPainter {
  final int levels;
  WindingPathPainter({required this.levels});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 3..style = PaintingStyle.stroke;
    var path = Path();
    path.moveTo(150 + 80 * sin(1 * 0.8), 2000 - (1 * 80) - 25);
    for (int i = 1; i <= levels; i++) {
       path.lineTo(150 + 80 * sin(i * 0.8), 2000.0 - (i * 80.0) - 25);
    }
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}