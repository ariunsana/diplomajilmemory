import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart'; // Ensure this file contains the Game model
import '../services/api_service.dart'; // API service to fetch game scores

class ScoreboardPage extends StatefulWidget {
  final String? playerName; // Make playerName optional

  const ScoreboardPage({super.key, this.playerName});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  List<Game> gameScores = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    setState(() => isLoading = true);
    try {
      // Fetch all game scores from API
      List<Game> scores = await _apiService.getGames();
      
      // If a specific player name is provided, filter their scores
      if (widget.playerName != null) {
        scores = scores.where((game) => game.playerName == widget.playerName).toList();
      }

      setState(() {
        gameScores = scores;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading scores: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          widget.playerName != null
              ? '${widget.playerName} - Онооны самбар'
              : 'Бүх тоглогчийн оноо',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : gameScores.isEmpty
              ? const Center(child: Text('Оноо олдсонгүй'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: gameScores.length,
                  itemBuilder: (context, index) {
                    final game = gameScores[index];
                    return Card(
                      color: Colors.grey[850],
                      child: ListTile(
                        title: Text(
                          '${game.playerName} - ${game.id}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Оноо: ${game.score} | ${game.playedAt}',
                          style: const TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
