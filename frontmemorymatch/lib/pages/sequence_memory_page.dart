import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class SequenceMemoryPage extends StatefulWidget {
  const SequenceMemoryPage({super.key});

  @override
  State<SequenceMemoryPage> createState() => _SequenceMemoryPageState();
}

class _SequenceMemoryPageState extends State<SequenceMemoryPage> {
  final List<String> _images = [
    'images/duck.png',
    'images/ufo.png',
    'images/orange.png',
    'images/brain.png',
    'images/giraffe.png',
    'images/sonic.png'
  ];
  
  late List<String> _currentRoundImages;
  
  bool _showingImages = true;
  bool _showingNumbers = false;
  bool _choosingAnswer = false;
  int _correctPosition = -1;
  int _selectedAnswer = -1;
  int _score = 0;
  int _currentLevel = 1;
  Timer? _timer;
  int _timeLeft = 30;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _gameOver(false);
        }
      });
    });
  }

  void _startNewRound() {
    _timer?.cancel();
    
    List<String> allImages = [
      'images/duck.png',
      'images/ufo.png',
      'images/orange.png',
      'images/brain.png',
      'images/giraffe.png',
      'images/sonic.png'
    ];
    
    allImages.shuffle();
    _correctPosition = Random().nextInt(6);
    _currentRoundImages = List.filled(6, '');
    String targetImage = allImages[0];
    _currentRoundImages[_correctPosition] = targetImage;
    
    int otherImageIndex = 1;
    for (int i = 0; i < 6; i++) {
      if (i != _correctPosition) {
        if (otherImageIndex >= allImages.length) {
          otherImageIndex = (otherImageIndex % allImages.length) + 1;
        }
        _currentRoundImages[i] = allImages[otherImageIndex];
        otherImageIndex++;
      }
    }

    setState(() {
      _showingImages = true;
      _showingNumbers = false;
      _choosingAnswer = false;
      _selectedAnswer = -1;
      _timeLeft = 60;
      _isGameOver = false;
    });

    _startTimer();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showingImages = false;
          _choosingAnswer = true;
        });
      }
    });
  }

  void _startNextLevel() {
    setState(() {
      _currentLevel++;
      _timeLeft = max(30 - (_currentLevel - 1) * 5, 15); // Decrease time with each level
    });
    _startNewRound();
  }

  void _gameOver(bool won) async {
    _timer?.cancel();
    _isGameOver = true;
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final playerId = prefs.getInt('playerId');
    final playerName = prefs.getString('playerName');

    if (won && _currentLevel < 5) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Баяр хүргэе!', style: TextStyle(color: Colors.white)),
          content: Text(
            'Level $_currentLevel дууслаа!\nНийт оноо: $_score\nLevel ${_currentLevel + 1}-т орж байна',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNextLevel();
              },
              child: const Text('Дараагийн түвшин'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text(
            won ? 'Баяр хүргэе!' : 'Тоглоом дууслаа!',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                won ? 'Та бүх түвшинг дууслаа!' : 'Цаг дууслаа!',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Нийт оноо: $_score',
                style: const TextStyle(color: Colors.white),
              ),
              if (playerName == null)
                const Text(
                  '\nТоглогчийн нэр бүртгэгдээгүй байна.',
                  style: TextStyle(color: Colors.orange),
                ),
            ],
          ),
          actions: [
            if (playerId != null) ...[
              TextButton(
                onPressed: () async {
                  try {
                    final apiService = ApiService();
                    await apiService.createGame(
                      playerId,
                      _score,
                      gameType: 'SEQUENCE_GAME',
                      gameName: 'Sequence Game Level $_currentLevel',
                    );
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Оноо амжилттай хадгалагдлаа!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                      setState(() {
                        _currentLevel = 1;
                        _score = 0;
                      });
                      _startNewRound();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Оноо хадгалахад алдаа гарлаа: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Оноо хадгалах', style: TextStyle(color: Colors.white)),
              ),
            ],
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentLevel = 1;
                  _score = 0;
                });
                _startNewRound();
              },
              child: const Text('Дахин тоглох', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  void _checkAnswer(int selected) {
    setState(() {
      _selectedAnswer = selected;
    });

    if (selected == _correctPosition) {
      setState(() {
        _score += _currentLevel * 10; // Increase points based on level
      });
      _gameOver(true);
    } else {
      _gameOver(false);
    }
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey[600]!,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            _currentRoundImages[index],
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _buildAnswerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _checkAnswer(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Дараалал санах - Level $_currentLevel',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _startNewRound,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Оноо: $_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Хугацаа: ${_formatTime(_timeLeft)}',
                      style: TextStyle(
                        color: _timeLeft <= 10 ? Colors.red : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _showingImages
                      ? 'Зургуудыг цээжлээрэй!'
                      : '${_currentRoundImages[_correctPosition].split('/').last.split('.').first} хаана байсан?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: _showingImages
                    ? _buildImageGrid()
                    : _buildAnswerGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
