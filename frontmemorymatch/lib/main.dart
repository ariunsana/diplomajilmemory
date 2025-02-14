import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MemoryMatchGame());
}

class MemoryMatchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemoryMatchHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MemoryMatchHomePage extends StatefulWidget {
  @override
  _MemoryMatchHomePageState createState() => _MemoryMatchHomePageState();
}

class _MemoryMatchHomePageState extends State<MemoryMatchHomePage> {
  List<String> cards = ['🍎', '🍎', '🍌', '🍌', '🍉', '🍉', '🍇', '🍇', '🍒', '🍒', '🥝', '🥝'];
  List<bool> revealed = List.filled(12, false);
  int? firstSelectedIndex;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    cards.shuffle(Random());
  }

  void onCardTap(int index) {
    if (revealed[index]) return;

    setState(() {
      revealed[index] = true;
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        moves++;
        if (cards[firstSelectedIndex!] != cards[index]) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              revealed[firstSelectedIndex!] = false;
              revealed[index] = false;
              firstSelectedIndex = null;
            });
          });
        } else {
          firstSelectedIndex = null;
        }
      }
    });
  }

  bool isGameFinished() {
    return revealed.every((card) => card);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                cards.shuffle(Random());
                revealed = List.filled(12, false);
                firstSelectedIndex = null;
                moves = 0;
              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Card(
                    color: revealed[index] ? Colors.amber : Colors.blueGrey,
                    child: Center(
                      child: Text(
                        revealed[index] ? cards[index] : '',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text('Moves: $moves', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          if (isGameFinished())
            Text('You won!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
