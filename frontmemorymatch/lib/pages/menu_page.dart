import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'username.dart';
import 'package:frontmemorymatch/pages/scoreboardPage.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? currentPlayerName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() => isLoading = true);
    try {
      // Load current player name from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('playerName');
      
      setState(() {
        currentPlayerName = savedName;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading player data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _promptForName() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (result == true) {
      _loadPlayerData(); // Reload data after new name is added
    }
  }

  Widget _buildPlayerSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Тоглогч: ${currentPlayerName ?? "Нэргүй"}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (currentPlayerName == null)
            TextButton(
              onPressed: _promptForName,
              child: const Text(
                'Нэр оруулах',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Буцах',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPlayerSection(),
                const SizedBox(height: 30),
                _buildMenuButton('Онооны самбар', () {
  if (currentPlayerName != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreboardPage(playerName: currentPlayerName!),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Эхлээд тоглогчийн нэр оруулна уу!")),
    );
  }
}),

                const SizedBox(height: 20),
                _buildMenuButton('Шинэ нэр оруулах', _promptForName),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
