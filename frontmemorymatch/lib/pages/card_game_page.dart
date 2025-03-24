import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CardGamePage extends StatefulWidget {
  const CardGamePage({super.key});

  @override
  State<CardGamePage> createState() => _CardGamePageState();
}

class _CardGamePageState extends State<CardGamePage> {
  List<bool> _flippedCards = [];
  List<bool> _matchedCards = [];
  List<String> _cardImages = [];
  int? _firstFlippedIndex;
  bool _canFlip = true;
  int _score = 0;
  Timer? _timer;
  int _timeLeft = 60;
  bool _isGameOver = false;
  int _currentLevel = 1;

  final List<String> _possibleImages = [
    'images/tamga.png',
    'images/geltamga.jpg',
    'images/kcard.jpg',
    'images/Qcard.jpg',
    'images/jcard.jpg',
    'images/10card.png',
    'images/9card.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _gameOver(false);
        }
      });
    });
  }

  void _gameOver(bool won) {
    _timer?.cancel();
    _isGameOver = true;
    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      
      // Get the current player's ID
      final prefs = await SharedPreferences.getInstance();
      final playerId = prefs.getInt('playerId');
      final playerName = prefs.getString('playerName');
      
      if (won && _currentLevel < 5) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Баяр хүргэе!'),
            content: Text('Level $_currentLevel дууслаа!\nНийт оноо: $_score\nLevel ${_currentLevel + 1}-т орж байна'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_currentLevel == 1) {
                    _startLevel2();
                  } else if (_currentLevel == 2) {
                    _startLevel3();
                  } else if (_currentLevel == 3) {
                    _startLevel4();
                  } else if (_currentLevel == 4) {
                    _startLevel5();
                  }
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
            title: Text(won ? 'Баяр хүргэе!' : 'Цаг дууслаа!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(won ? 'Та бүх түвшинг дууслаа!' : 'Цаг дууслаа!'),
                Text('Нийт оноо: $_score'),
                if (playerName == null)
                  const Text('\nТоглогчийн нэр бүртгэгдээгүй байна.',
                    style: TextStyle(color: Colors.orange)),
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
                        gameType: 'CARD_GAME',
                        gameName: 'Card Game Level $_currentLevel',
                      );
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Оноо амжилттай хадгалагдлаа!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                        _initializeGame();
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
                  child: const Text('Оноо хадгалах'),
                ),
                const SizedBox(width: 8),
              ],
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initializeGame();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Дахин тоглох'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _startLevel2() {
    setState(() {
      _currentLevel = 2;
      _flippedCards = List.generate(8, (_) => false);
      _matchedCards = List.generate(8, (_) => false);
      _firstFlippedIndex = null;
      _canFlip = true;
      _timeLeft = 60;
      _isGameOver = false;

      _cardImages = [
        'images/tamga.png',
        'images/tamga.png',
        'images/geltamga.jpg',
        'images/geltamga.jpg',
        'images/kcard.jpg',
        'images/kcard.jpg',
        'images/Qcard.jpg',
        'images/Qcard.jpg',
      ];

      _cardImages.shuffle();
    });
    _startTimer();
  }

  void _startLevel3() {
    setState(() {
      _currentLevel = 3;
      _flippedCards = List.generate(10, (_) => false);
      _matchedCards = List.generate(10, (_) => false);
      _firstFlippedIndex = null;
      _canFlip = true;
      _timeLeft = 90;
      _isGameOver = false;

      _cardImages = [
        'images/tamga.png',
        'images/tamga.png',
        'images/geltamga.jpg',
        'images/geltamga.jpg',
        'images/kcard.jpg',
        'images/kcard.jpg',
        'images/Qcard.jpg',
        'images/Qcard.jpg',
        'images/jcard.jpg',
        'images/jcard.jpg',
      ];

      _cardImages.shuffle();
    });
    _startTimer();
  }

  void _startLevel4() {
    setState(() {
      _currentLevel = 4;
      _flippedCards = List.generate(12, (_) => false);
      _matchedCards = List.generate(12, (_) => false);
      _firstFlippedIndex = null;
      _canFlip = true;
      _timeLeft = 120;
      _isGameOver = false;

      _cardImages = [
        'images/tamga.png',
        'images/tamga.png',
        'images/geltamga.jpg',
        'images/geltamga.jpg',
        'images/kcard.jpg',
        'images/kcard.jpg',
        'images/Qcard.jpg',
        'images/Qcard.jpg',
        'images/jcard.jpg',
        'images/jcard.jpg',
        'images/10card.png',
        'images/10card.png',
      ];

      _cardImages.shuffle();
    });
    _startTimer();
  }

  void _startLevel5() {
    setState(() {
      _currentLevel = 5;
      _flippedCards = List.generate(14, (_) => false);
      _matchedCards = List.generate(14, (_) => false);
      _firstFlippedIndex = null;
      _canFlip = true;
      _timeLeft = 150;
      _isGameOver = false;

      _cardImages = [
        'images/tamga.png',
        'images/tamga.png',
        'images/geltamga.jpg',
        'images/geltamga.jpg',
        'images/kcard.jpg',
        'images/kcard.jpg',
        'images/Qcard.jpg',
        'images/Qcard.jpg',
        'images/jcard.jpg',
        'images/jcard.jpg',
        'images/10card.png',
        'images/10card.png',
        'images/9card.jpg',
        'images/9card.jpg',
      ];

      _cardImages.shuffle();
    });
    _startTimer();
  }

  void _initializeGame() {
    _timer?.cancel();
    setState(() {
      _currentLevel = 1;
      _flippedCards = List.generate(6, (_) => false);
      _matchedCards = List.generate(6, (_) => false);
      _firstFlippedIndex = null;
      _canFlip = true;
      _score = 0;
      _timeLeft = 60;
      _isGameOver = false;

      _cardImages = [
        'images/tamga.png',
        'images/tamga.png',
        'images/geltamga.jpg',
        'images/geltamga.jpg',
        'images/kcard.jpg',
        'images/kcard.jpg',
      ];

      _cardImages.shuffle();
    });
    _startTimer();
  }

  int _calculatePoints(String firstCard, String secondCard) {
    if (firstCard == secondCard) {
      if (firstCard == 'images/geltamga.jpg') {
        return 1;
      } else if (firstCard == 'images/tamga.png') {
        return 1;
      } else if (firstCard == 'images/kcard.jpg') {
        return 1;
      } else if (firstCard == 'images/Qcard.jpg') {
        return 2;
      } else if (firstCard == 'images/jcard.jpg') {
        return 3;
      } else if (firstCard == 'images/10card.png') {
        return 4;
      } else if (firstCard == 'images/9card.jpg') {
        return 5;
      }
    }
    return 0;
  }

  bool _isMatch(String firstCard, String secondCard) {
    return firstCard == secondCard;
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void _handleCardTap(int index) {
    if (_isGameOver || !_canFlip || _flippedCards[index] || _matchedCards[index]) return;

    setState(() {
      _flippedCards[index] = true;
      if (_firstFlippedIndex == null) {
        _firstFlippedIndex = index;
      } else {
        _canFlip = false;
        if (_isMatch(_cardImages[_firstFlippedIndex!], _cardImages[index])) {
          _matchedCards[_firstFlippedIndex!] = true;
          _matchedCards[index] = true;
          _score += _calculatePoints(_cardImages[_firstFlippedIndex!], _cardImages[index]);
          _firstFlippedIndex = null;
          _canFlip = true;
          
          if (_matchedCards.every((matched) => matched)) {
            _gameOver(true);
          }
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              _flippedCards[_firstFlippedIndex!] = false;
              _flippedCards[index] = false;
              _firstFlippedIndex = null;
              _canFlip = true;
            });
          });
        }
      }
    });
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
          'Хөзрийн тоглоом - Level $_currentLevel',
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _initializeGame,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Оноо: $_score',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _currentLevel == 5 ? MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.width * 0.1,
                      vertical: 20,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _currentLevel == 5 ? 4 : (_currentLevel >= 3 ? 4 : 3),
                        crossAxisSpacing: _currentLevel == 5 ? 8 : 10,
                        mainAxisSpacing: _currentLevel == 5 ? 8 : 10,
                        childAspectRatio: _currentLevel == 5 ? 0.8 : (_currentLevel >= 3 ? 0.7 : 0.65),
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _currentLevel == 1 ? 6 : (_currentLevel == 2 ? 8 : (_currentLevel == 3 ? 10 : (_currentLevel == 4 ? 12 : 14))),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _handleCardTap(index),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return RotationYTransition(turns: animation, child: child);
                            },
                            child: _flippedCards[index]
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        _cardImages[index],
                                        key: ValueKey(_cardImages[index] + index.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'images/cart_back.png',
                                        key: ValueKey('back_$index'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
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

class RotationYTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> turns;

  const RotationYTransition({super.key, required this.child, required this.turns});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: turns,
      child: child,
      builder: (context, child) {
        final angle = turns.value * math.pi;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
