import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  final double fillPercentage;

  RPSCustomPainter({required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    // Main shape path
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8749978, size.height * 0.6250004);
    path_0.cubicTo(size.width * 0.8749978, size.height * 0.4250019, size.width * 0.5312488, size.height * 0.03437526, size.width * 0.5031229, size.height * 0.003124699);
    path_0.lineTo(size.width * 0.5031229, size.height * 0.003124699);
    // Additional cubicTo points...
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xff3CAED6).withValues(alpha: 1.0);
    canvas.drawPath(path_0, paint0Fill);

    // Fill color path with dynamic height based on fillPercentage from the bottom up
    Path path_1 = Path();
    double fillHeight = size.height * fillPercentage / 100;
    double startY = size.height - fillHeight; // Start filling from the bottom

    path_1.moveTo(size.width * 0.6562510, startY);
    path_1.cubicTo(
      size.width * 0.6218757,
      startY,
      size.width * 0.5937499,
      startY + (size.height * 0.0625029),
      size.width * 0.5937499,
      startY + (size.height * 0.1250029),
    );
    // Additional cubicTo points adjusted...
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xff63BFDE).withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// // Usage
// CustomPaint(
//   size: Size(200, 200), // Replace with desired width and height
//   painter: RPSCustomPainter(fillPercentage: 50), // Adjust fill percentage
// )
