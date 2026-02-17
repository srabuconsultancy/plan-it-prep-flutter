/*class WaterTrackerWidget extends StatelessWidget {
  final DashboardController controller = Get.find();

  WaterTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Water',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Goal: 64 fl oz'),
            const SizedBox(height: 10),
            Obx(() => Text(
                  '${controller.totalWater} fl oz',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 16),
            Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(9, (index) {
                    bool filled = index < controller.cupsFilled.value;
                    return GestureDetector(
                      onTap: () => controller.toggleCup(index),
                      child: Container(
                        width: 48,
                        height: 80,
                        decoration: BoxDecoration(
                          color: filled ? Colors.blueAccent : Colors.white,
                          border: Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          filled ? Icons.local_drink : Icons.local_drink_outlined,
                          color: filled ? Colors.white : Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                    );
                  }),
                )),
            const SizedBox(height: 16),
            const Text('+ Water from food: 0.0 fl oz'),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import '../../../core.dart';

class WaterTrackerWidget extends StatelessWidget {
  final DashboardController controller = Get.find();

  WaterTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '💧 Water Intake',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: glDarkPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              'Goal: ${DashboardService.to.data.value.todayMacros.water} Litres (${DashboardService.to.data.value.todayMacros.water / 0.3} glasses)',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
                  controller.totalWater > 900 ? '${controller.totalWater / 1000} L' : '${controller.totalWater} ml',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade300,
                  ),
                )),
            const SizedBox(height: 16),
            Obx(() {
              double progress = controller.totalWater / 2400;
              return LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(16),
                backgroundColor: Colors.lightBlue.shade100,
                color: Colors.lightBlue.shade300,
              );
            }),
            const SizedBox(height: 20),

            /// Smart Cups Grid
            const WaterTrackerSmartGlasses(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class WaterTrackerSmartGlasses extends StatelessWidget {
  const WaterTrackerSmartGlasses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() {
      int cupsFilled = controller.cupsFilled.value;
      int maxGlasses = 15;
      final int targetGlasses = (DashboardService.to.data.value.todayMacros.water / 0.3).toInt();

      // Render current filled + 1 glass with plus sign
      int totalToRender = cupsFilled < targetGlasses
          ? targetGlasses
          : cupsFilled < maxGlasses
              ? cupsFilled + 1
              : maxGlasses;

      return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: List.generate(totalToRender, (index) {
          bool isFilled = index < cupsFilled;
          bool isPlus = index == cupsFilled && cupsFilled < maxGlasses;
          bool isGoalAchievedGlass = index == targetGlasses - 1 && cupsFilled >= targetGlasses;

          return GestureDetector(
            onTap: () => controller.toggleCup(index),
            child: Stack(
              children: [
                AnimatedGlassWidget(targetPercent: isFilled ? 0.85 : 0.0),
                if (isPlus)
                  const Positioned.fill(
                    child: Center(
                      child: Icon(Icons.add, color: Colors.blueAccent, size: 28),
                    ),
                  ),
                if (isGoalAchievedGlass)
                  Positioned(
                    bottom: 3,
                    right: -1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white54,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        TablerIcons.circle_check_filled,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ).animate().fadeIn(duration: 900.ms, delay: 100.ms).slideY(),
              ],
            ),
          );
        }),
      );
    });
  }
}

class GlassData {
  bool isFilled;

  GlassData({this.isFilled = false});
}

/*class SimpleGlassPainter extends CustomPainter {
  final double fillPercent; // 0.0 = empty, 1.0 = full

  SimpleGlassPainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    // Glass shape (wider)
    Path glassPath = Path()
      ..moveTo(size.width * 0.15, 0)
      ..lineTo(size.width * 0.85, 0)
      ..lineTo(size.width * 0.70, size.height)
      ..lineTo(size.width * 0.30, size.height)
      ..close();

    // Clip the fill based on percentage
    if (fillPercent > 0) {
      final fillHeight = size.height * fillPercent;
      final fillPath = Path()
        ..moveTo(size.width * 0.30, size.height)
        ..lineTo(size.width * 0.70, size.height)
        ..lineTo(size.width * 0.85, size.height - fillHeight)
        ..lineTo(size.width * 0.15, size.height - fillHeight)
        ..close();

      canvas.save();
      canvas.clipPath(glassPath);
      canvas.drawPath(fillPath, fillPaint);
      canvas.restore();

      // Add bubbles
      final bubblePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(size.width * 0.5, size.height - fillHeight + 10), 2, bubblePaint);
      canvas.drawCircle(Offset(size.width * 0.45, size.height - fillHeight + 25), 1.5, bubblePaint);
    }

    canvas.drawPath(glassPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant SimpleGlassPainter oldDelegate) {
    return oldDelegate.fillPercent != fillPercent;
  }
}*/
class SimpleGlassPainter extends CustomPainter {
  final double fillPercent;

  SimpleGlassPainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final glassFillPaint = Paint()
      ..color = Colors.lightBlue.shade300
      ..style = PaintingStyle.fill;

    final glassShadePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.4), Colors.transparent, Colors.white.withValues(alpha: 0.2)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Glass shape with flat bottom and curved top
    Path glassPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.05)
      ..quadraticBezierTo(size.width * 0.5, 0, size.width * 0.85, size.height * 0.05) // curved top
      ..lineTo(size.width * 0.70, size.height)
      ..lineTo(size.width * 0.30, size.height)
      ..lineTo(size.width * 0.15, size.height * 0.05)
      ..close();

    // Water fill
    if (fillPercent > 0) {
      double fillHeight = size.height * fillPercent;

      Path fillPath = Path()
        ..moveTo(size.width * 0.30, size.height)
        ..lineTo(size.width * 0.70, size.height)
        ..lineTo(size.width * 0.85, size.height - fillHeight)
        ..lineTo(size.width * 0.15, size.height - fillHeight)
        ..close();

      canvas.save();
      canvas.clipPath(glassPath);
      canvas.drawPath(fillPath, glassFillPaint);
      canvas.restore();

      // Optional water bubbles
      final bubblePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(size.width * 0.5, size.height - fillHeight + 10), 2, bubblePaint);
      canvas.drawCircle(Offset(size.width * 0.45, size.height - fillHeight + 25), 1.5, bubblePaint);
    }

    // Shading on glass
    canvas.drawPath(glassPath, glassShadePaint);

    // Glass border
    // canvas.drawPath(glassPath, glassBorderPaint);
  }

  @override
  bool shouldRepaint(covariant SimpleGlassPainter oldDelegate) {
    return oldDelegate.fillPercent != fillPercent;
  }
}

class AnimatedGlassWidget extends StatefulWidget {
  final double targetPercent; // 0.0 to 1.0

  const AnimatedGlassWidget({super.key, required this.targetPercent});

  @override
  State<AnimatedGlassWidget> createState() => _AnimatedGlassWidgetState();
}

class _AnimatedGlassWidgetState extends State<AnimatedGlassWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 0, end: widget.targetPercent).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedGlassWidget oldWidget) {
    if (oldWidget.targetPercent != widget.targetPercent) {
      _animation = Tween<double>(begin: _animation.value, end: widget.targetPercent).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 55,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => CustomPaint(
          painter: SimpleGlassPainter(fillPercent: _animation.value),
        ),
      ),
    );
  }
}
