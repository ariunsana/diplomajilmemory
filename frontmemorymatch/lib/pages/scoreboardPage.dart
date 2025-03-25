import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart'; // Ensure this file contains the Game model
import '../services/api_service.dart'; // API service to fetch game scores

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  List<Game> gameScores = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();
  String sortBy = 'score'; // 'score' or 'name'

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    setState(() => isLoading = true);
    try {
      List<Game> scores = await _apiService.getGames();
      
      // Sort scores based on selected criteria
      scores.sort((a, b) {
        if (sortBy == 'name') {
          return a.playerName.compareTo(b.playerName);
        } else {
          return b.score.compareTo(a.score); // High score first
        }
      });

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          'Онооны самбар',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            color: Colors.grey[850],
            onSelected: (String value) {
              setState(() {
                sortBy = value;
                _loadScores();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'score',
                child: Row(
                  children: [
                    Icon(Icons.emoji_events,
                         color: sortBy == 'score' ? Colors.blue : Colors.white,
                         size: 20),
                    const SizedBox(width: 8),
                    Text('Өндөр оноогоор',
                        style: TextStyle(
                          color: sortBy == 'score' ? Colors.blue : Colors.white,
                        )),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha,
                         color: sortBy == 'name' ? Colors.blue : Colors.white,
                         size: 20),
                    const SizedBox(width: 8),
                    Text('Нэрээр эрэмбэлэх',
                        style: TextStyle(
                          color: sortBy == 'name' ? Colors.blue : Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : gameScores.isEmpty
                ? const Center(
                    child: Text(
                      'Оноо олдсонгүй',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: gameScores.length,
                    itemBuilder: (context, index) {
                      final game = gameScores[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey[850]!,
                              Colors.grey[900]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue.withOpacity(0.2),
                                          child: Text(
                                            game.playerName[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            game.playerName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.green, Colors.teal],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Оноо: ${game.score}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.style,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    game.gameType ?? "Memory Match",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
