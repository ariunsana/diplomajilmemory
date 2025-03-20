import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SequenceMemoryPage extends StatefulWidget {
  const SequenceMemoryPage({super.key});

  @override
  State<SequenceMemoryPage> createState() => _SequenceMemoryPageState();
}

class _SequenceMemoryPageState extends State<SequenceMemoryPage> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  List<int> _sequence = [];
  List<int> _playerSequence = [];
  bool _isPlaying = false;
  bool _canPlayerInput = false;
  int _currentHighlight = -1;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _sequence = [];
      _playerSequence = [];
      _isPlaying = true;
      _canPlayerInput = false;
    });
    _addToSequence();
  }

  void _addToSequence() {
    setState(() {
      _sequence.add(Random().nextInt(9));
      _playerSequence = [];
    });
    _playSequence();
  }

  Future<void> _playSequence() async {
    _canPlayerInput = false;
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < _sequence.length; i++) {
      if (!_isPlaying) return;

      setState(() => _currentHighlight = _sequence[i]);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _currentHighlight = -1);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      _canPlayerInput = true;
      _currentHighlight = -1;
    });
  }

  void _onTilePressed(int index) {
    if (!_canPlayerInput || !_isPlaying) return;

    setState(() {
      _playerSequence.add(index);
      _currentHighlight = index;
    });

    if (_playerSequence.last != _sequence[_playerSequence.length - 1]) {
      _gameOver();
      return;
    }

    if (_playerSequence.length == _sequence.length) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() => _currentHighlight = -1);
        _addToSequence();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() => _currentHighlight = -1);
      });
    }
  }

  void _gameOver() {
    setState(() {
      _isPlaying = false;
      _canPlayerInput = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('Retry'),
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
        backgroundColor: Colors.grey[900],
        title: const Text('Level 1', style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _onTilePressed(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _currentHighlight == index ? Colors.white : Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
