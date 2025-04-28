import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/direction.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/control_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> _snakePosition = []; // 蛇佔據的格子 index
  int _foodPosition = -1; // 食物位置 index
  Direction _direction = Direction.right; // 初始方向
  GameState _gameState = GameState.start; // 初始狀態
  Timer? _gameTimer; // 遊戲循環計時器
  int _score = 0;
  int _currentGameSpeed = initialGameSpeed; // 目前速度

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gameTimer?.cancel(); // 離開頁面時取消計時器
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _currentGameSpeed = initialGameSpeed;
      // 初始蛇位置
      int startPos = (rowSize * colSize ~/ 2) + colSize ~/ 4;
      _snakePosition = [startPos - 2, startPos - 1, startPos];
      _direction = Direction.right; // 初始向右
      _placeFood(); // 放置第一個食物
      _gameState = GameState.playing;
    });

    _gameTimer?.cancel(); // 取消舊的 Timer (如果有的話)
    _gameTimer = Timer.periodic(
      Duration(milliseconds: _currentGameSpeed),
      _gameLoop,
    );
  }

  void _gameLoop(Timer timer) {
    if (_gameState != GameState.playing) return; // 非遊戲中則跳過

    setState(() {
      _moveSnake();
      if (_checkCollision()) {
        _gameOver();
      } else {
        _checkEatFood();
      }
    });
  }

  void _moveSnake() {
    int headPos = _snakePosition.last;
    int nextPos;

    // 計算下一個頭部位置
    switch (_direction) {
      case Direction.up:
        nextPos = headPos - colSize;
        // 處理穿牆
        if (nextPos < 0) nextPos += totalSquares;
        break;
      case Direction.down:
        nextPos = headPos + colSize;
        // 處理穿牆
        if (nextPos >= totalSquares) nextPos -= totalSquares;
        break;
      case Direction.left:
        nextPos = headPos - 1;
        // 處理穿牆 (判斷是否在最左邊)
        if (headPos % colSize == 0) nextPos += colSize;
        break;
      case Direction.right:
        nextPos = headPos + 1;
        // 處理穿牆 (判斷是否在最右邊)
        if (nextPos % colSize == 0) nextPos -= colSize;
        break;
    }

    // 加入新的頭部
    _snakePosition.add(nextPos);

    // 如果沒有吃到食物，移除尾巴
    if (nextPos != _foodPosition) {
      _snakePosition.removeAt(0);
    }
  }

  void _placeFood() {
    final random = Random();
    int potentialFoodPos;
    do {
      potentialFoodPos = random.nextInt(totalSquares);
    } while (_snakePosition.contains(potentialFoodPos)); // 確保食物不生成在蛇身上
    setState(() {
      _foodPosition = potentialFoodPos;
    });
  }

  void _checkEatFood() {
    if (_snakePosition.last == _foodPosition) {
      setState(() {
        _score++;
        // 加速 
        if (_currentGameSpeed > minSpeed) {
          _currentGameSpeed = max(minSpeed, _currentGameSpeed - speedDecrease);
          _gameTimer?.cancel(); // 取消舊 timer
          _gameTimer = Timer.periodic(
            Duration(milliseconds: _currentGameSpeed),
            _gameLoop,
          ); // 用新速度重啟 timer
        }
        // 不要移除尾巴 (蛇變長)
        _placeFood(); // 重新放置食物
      });
    }
  }

  bool _checkCollision() {
    int headPos = _snakePosition.last;

    // 檢查是否撞到自身 (除了頭部以外的部分)
    for (int i = 0; i < _snakePosition.length - 1; i++) {
      if (headPos == _snakePosition[i]) {
        return true; // 撞到自己
      }
    }

    return false; // 沒有碰撞
  }

  void _gameOver() {
    _gameTimer?.cancel();
    setState(() {
      _gameState = GameState.gameOver;
    });
  }

  void _handleDirectionChange(Direction newDirection) {
    if (_gameState != GameState.playing) return; // 遊戲沒在進行時不改變方向

    // 防止直接反向移動
    if (_direction == Direction.up && newDirection == Direction.down) return;
    if (_direction == Direction.down && newDirection == Direction.up) return;
    if (_direction == Direction.left && newDirection == Direction.right) return;
    if (_direction == Direction.right && newDirection == Direction.left) return;

    // 更新方向 (下一個 gameLoop 就會使用新方向)
    setState(() {
      _direction = newDirection;
    });
  }

  Widget _buildGameOverlay() {
    switch (_gameState) {
      case GameState.start:
        return _buildOverlayWidget("點擊開始", "開始遊戲", _startGame);
      case GameState.gameOver:
        return _buildOverlayWidget(
          "Build Failed!\n分數: $_score", 
          "重新開始",
          _startGame,
          isError: true, // 紅色背景
        );
      case GameState.playing:
        return Container(); // 遊戲中不顯示遮罩
    }
  }

  Widget _buildOverlayWidget(
    String message,
    String buttonText,
    VoidCallback onPressed, {
    bool isError = false,
  }) {
    return Positioned.fill(
      // 填滿整個棋盤區域
      child: Container(
        color:
            isError
                ? Colors.red.withAlpha((255 * 0.9).round())
                : Colors.black.withAlpha((255 * 0.9).round()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isError ? Colors.yellow : Colors.white, // 錯誤訊息用黃色
                  fontFamily: isError ? 'monospace' : null, // 錯誤訊息用等寬字體
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isError ? Colors.white : Colors.lightBlue,
                  foregroundColor: isError ? Colors.red : Colors.white,
                ),
                onPressed: onPressed,
                child: Text(buttonText, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Flutter Snake Game',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: Column(
        children: [
          // 分數顯示
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              'Score : $_score', 
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // 遊戲棋盤區域 (使用 Stack 來疊加遮罩)
          Expanded(
            child: Stack(
              children: [
                GameBoard(
                  snakePosition: _snakePosition,
                  foodPosition: _foodPosition,
                  gameState: _gameState,
                ),
                _buildGameOverlay(), // 遊戲狀態遮罩 (開始/結束)
              ],
            ),
          ),

          // 控制按鈕
          if (_gameState != GameState.gameOver) // Game Over 時可以隱藏控制
            ControlPanel(
              onDirectionChanged: _handleDirectionChange, // 傳遞回調函數
            ),
          // Game Over 時留點空間或顯示其他信息
          if (_gameState == GameState.gameOver)
            const SizedBox(height: 80), 
        ],
      ),
    );
  }
}
