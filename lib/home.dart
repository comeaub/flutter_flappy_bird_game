import 'dart:async';

import 'package:flappy_bird_game/barriers.dart';
import 'package:flappy_bird_game/bird.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late int score = 0;
  late int bestScore = 0;

  double initialHeight = birdYaxis;
  bool gameHasStarted = false;

  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
      score++;
    });
    if (score >= bestScore) {
      bestScore = score;
    }
  }

  bool birdIsDead() {
    if (birdYaxis > 1 || birdYaxis < -1) {
      return true;
    }
    return false;
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.2 * time;

      setState(() {
        birdYaxis = initialHeight - height;
        setState(() {
          if (barrierXone < -1.1) {
            barrierXone += 2.2;
          } else {
            barrierXone -= 0.04;
          }
        });

        if (birdIsDead()) {
          timer.cancel();
          _showDialog();
        }

        setState(() {
          if (barrierXtwo < -1.1) {
            barrierXtwo += 2.2;
          } else {
            barrierXtwo -= 0.05;
          }
        });
      });
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Center(
              child: Image.asset('lib/images/game_over.png'),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(
                      "Start Again",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: const Duration(milliseconds: 0),
                      color: Colors.lightBlueAccent,
                      child: const Bird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.65),
                      child: gameHasStarted
                          ? Text("")
                          : Image.asset('lib/images/play.png'),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Barriers(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.5),
                      duration: Duration(milliseconds: 0),
                      child: Barriers(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.2),
                      duration: Duration(milliseconds: 0),
                      child: Barriers(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.2),
                      duration: Duration(milliseconds: 0),
                      child: Barriers(
                        size: 250.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 10,
              color: Colors.amberAccent,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Image.asset(
                          'lib/images/score.png',
                          width: 80,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'SCORE',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Image.asset(
                          'lib/images/top.png',
                          width: 78,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          bestScore.toString(),
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
