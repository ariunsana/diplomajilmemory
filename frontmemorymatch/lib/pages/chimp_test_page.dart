import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ChimpTestPage extends StatefulWidget {
  const ChimpTestPage({super.key});

  @override
  State<ChimpTestPage> createState() => _ChimpTestPageState();
}

class _ChimpTestPageState extends State<ChimpTestPage> {
  List<int> _numbers = [];
  List<Offset> _positions = [];
  int _currentLevel = 1;
  int _score = 0;
  int _nextNumberToClick = 1;
  int _maxNumber = 0;
  bool _isGameOver = false;
  bool _hasClickedFirst = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewRound();
    });
  }

  void _startNewRound() {
    // Start with 4 numbers in level 1, add more numbers in subsequent levels
    _maxNumber = 4 + (_currentLevel - 1);
    _numbers = List.generate(_maxNumber, (index) => index + 1);
    
    if (mounted) {
      _generateRandomPositions();
      setState(() {
        _nextNumberToClick = 1;
        _hasClickedFirst = false;
        _isGameOver = false;
      });
    }
  }

  void _generateRandomPositions() {
    if (!mounted) return;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width - 120; // More padding for edges
    final screenHeight = size.height - 250; // More padding for top and bottom
    _positions = [];

    for (int i = 0; i < _numbers.length; i++) {
      bool validPosition = false;
      Offset newPosition;

      while (!validPosition) {
        newPosition = Offset(
          20 + _random.nextDouble() * screenWidth,  // Add minimum edge padding
          100 + _random.nextDouble() * screenHeight, // Add minimum top padding
        );

        // Check if the new position overlaps with existing positions
        validPosition = true;
        for (var pos in _positions) {
          if ((pos - newPosition).distance < 120) { // Increased minimum distance between squares
            validPosition = false;
            break;
          }
        }

        if (validPosition) {
          _positions.add(newPosition);
        }
      }
    }
  }

  void _startNextLevel() {
    setState(() {
      _currentLevel++;
    });
    _startNewRound();
  }

  void _gameOver(bool won) async {
    _isGameOver = true;
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final playerId = prefs.getInt('playerId');
    final playerName = prefs.getString('playerName');

    if (won) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Баяр хүргэе!', style: TextStyle(color: Colors.white)),
          content: Text(
            'Level $_currentLevel дууслаа!\nНийт оноо: $_score\nДараагийн түвшинд ${_maxNumber + 1} тоо байх болно',
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
          title: const Text('Тоглоом дууслаа!', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Буруу дарлаа!',
                style: TextStyle(color: Colors.white),
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
                      gameType: 'CHIMP_TEST',
                      gameName: 'Chimp Test Level $_currentLevel',
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

  void _checkAnswer(int number) {
    if (number == _nextNumberToClick) {
      setState(() {
        if (_nextNumberToClick == 1) {
          _hasClickedFirst = true;
        }
        _nextNumberToClick++;
        if (_nextNumberToClick > _maxNumber) {
          _score += _currentLevel * 10;
          _gameOver(true);
        }
      });
    } else {
      _gameOver(false);
    }
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
          'Дараалалын санах ой - Level $_currentLevel',
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
        child: Stack(
          children: [
            for (int i = 0; i < _numbers.length; i++)
              if (_positions.length > i && (_currentLevel == 1 ? _numbers[i] >= _nextNumberToClick : (_numbers[i] >= _nextNumberToClick)))
                Positioned(
                  left: _positions[i].dx,
                  top: _positions[i].dy,
                  child: GestureDetector(
                    onTap: () => _checkAnswer(_numbers[i]),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          _numbers[i].toString(),
                          style: TextStyle(
                            color: _currentLevel == 1 
                                ? Colors.black
                                : (!_hasClickedFirst
                                    ? Colors.black
                                    : Colors.transparent),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
} 