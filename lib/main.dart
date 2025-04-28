import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameScreen(), // 設定遊戲畫面為首頁
      debugShowCheckedModeBanner: false, 
    );
  }
}