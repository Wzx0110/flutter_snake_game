import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/game_state.dart'; 

class GameBoard extends StatelessWidget {
  final List<int> snakePosition;
  final int foodPosition;
  final GameState gameState;

  const GameBoard({
    super.key, 
    required this.snakePosition,
    required this.foodPosition,
    required this.gameState,
  }); 

  @override
  Widget build(BuildContext context) {
    // 使用 MediaQuery 取得螢幕寬度，讓棋盤盡量填滿寬度
    double screenWidth = MediaQuery.of(context).size.width;
    // 計算每個格子的理想大小，減去一些 padding
    double cellSize = (screenWidth - 32.0) / colSize; // 32 是左右 padding

    return Center(
      child: Container(
        width: cellSize * colSize,
        height: cellSize * rowSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2), // 邊框
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // 禁止滾動
          itemCount: totalSquares,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colSize,
          ),
          itemBuilder: (context, index) {
            // 蛇身體
            if (snakePosition.contains(index)) {
              // 蛇頭顏色不同 
              final isHead = snakePosition.last == index;
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isHead ? Colors.blue[700] : snakeColor,
                  borderRadius: BorderRadius.circular(5), // 圓角 Widget
                ),
              );
            }
            // 食物
            else if (index == foodPosition) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black, // 背景色
                ),
                child: const Center(
                  child: Icon(
                    Icons.flash_on, // 閃電
                    color: foodColor,
                    size: 20, 
                  ),
                ),
              );
            }
            // 空白格子
            else {
              return Container(
                 decoration: BoxDecoration(
                   color: Colors.black, // 背景色
                 ),
              );
            }
          },
        ),
      ),
    );
  }
}