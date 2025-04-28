import 'package:flutter/material.dart';

// 格子總數 
const int rowSize = 20;
const int colSize = 20;
const int totalSquares = rowSize * colSize;

// 遊戲速度 (ms)
const int initialGameSpeed = 300; // 初始速度，數字越小越快
const int speedDecrease = 20; // 每吃到一個食物減少的時間
const int minSpeed = 80; // 最快速度

// 顏色
const Color backgroundColor = Color(0xFF282c34); // 暗色背景
const Color snakeColor = Colors.lightBlueAccent; // Flutter 藍
const Color foodColor = Colors.yellowAccent; // 閃電顏色
const Color gameOverTextColor = Colors.white;
