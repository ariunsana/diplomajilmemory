import 'package:flutter/material.dart';
import 'pages/menu_page.dart';
import 'pages/card_game_page.dart';
import 'pages/sequence_memory_page.dart';

void main() {
  runApp(const MemoryGamesApp());
}

class MemoryGamesApp extends StatelessWidget {
  const MemoryGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToGame(BuildContext context, String game) {
    switch (game) {
      case 'Хөзрийн тоглоом':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardGamePage()),
        );
        break;
      case 'Дараалал санах ой':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SequenceMemoryPage()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$game тоглоомыг тун удахгүй нээх болно!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.05; // 5% of screen width for padding

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'memorygames',
          style: TextStyle(
            fontFamily: 'Cursive',
            fontSize: screenSize.width * 0.07, // Responsive font size
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1a1a1a)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  _buildGameCard(
                    context,
                    Icons.style,
                    'Хөзрийн тоглоом',
                    'Хөзөр нь дээр дарж хос хосоор нь нийлүүлээрэй',
                    Colors.blue,
                    () => _navigateToGame(context, 'Хөзрийн тоглоом'),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildGameCard(
                    context,
                    Icons.grid_3x3,
                    'Дараалал санах ой',
                    'Асуултын зөв хариултыг олоорой',
                    Colors.green,
                    () => _navigateToGame(context, 'Дараалал санах ой'),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildGameCard(
                    context,
                    Icons.grid_on,
                    'Харааны санах ой',
                    'Өсөн нэмэгдэх буй дөрвөлжин самбарыг санаарай',
                    Colors.orange,
                    () => _navigateToGame(context, 'Харааны санах ой'),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.12; // Responsive icon size
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 600, // Maximum width on larger devices
            minHeight: screenSize.height * 0.15, // Minimum height relative to screen
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: color,
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: Colors.black87.withOpacity(0.7),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
