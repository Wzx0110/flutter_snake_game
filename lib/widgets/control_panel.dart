import 'package:flutter/material.dart';
import '../models/direction.dart';

typedef DirectionCallback = void Function(Direction direction);

class ControlPanel extends StatelessWidget {
  final DirectionCallback onDirectionChanged;

  const ControlPanel({
    super.key, 
    required this.onDirectionChanged,
  }); 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(Icons.keyboard_arrow_up, Direction.up),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.keyboard_arrow_left, Direction.left),
              const SizedBox(width: 60), // 間隔
              _buildControlButton(Icons.keyboard_arrow_right, Direction.right),
            ],
          ),
          _buildControlButton(Icons.keyboard_arrow_down, Direction.down),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Direction direction) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 30),
      onPressed: () => onDirectionChanged(direction), // 傳遞方向
    );
  }
}