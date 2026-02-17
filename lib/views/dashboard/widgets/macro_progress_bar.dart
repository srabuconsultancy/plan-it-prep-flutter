import 'package:flutter/material.dart';

class MacroProgressBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double goal;
  final Color color;

  const MacroProgressBar({
    super.key,
    required this.label,
    required this.consumed,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = (consumed / goal).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          '${consumed.toStringAsFixed(1)}/${goal.toStringAsFixed(1)}g',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 100,
            color: Colors.grey.shade200,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 100 * value,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
