import 'package:flutter/material.dart';
import 'login_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton('Онооны самбар', () {}),
            const SizedBox(height: 20),
            _buildMenuButton('Нэвтрэх', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }),
            const SizedBox(height: 20),
            _buildMenuButton('Гарах', () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
          ],
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
