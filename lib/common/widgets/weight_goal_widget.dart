import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class WeightGoalWidget extends StatefulWidget {
  const WeightGoalWidget({super.key});

  @override
  State<WeightGoalWidget> createState() => _WeightGoalWidgetState();
}

class _WeightGoalWidgetState extends State<WeightGoalWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double cardWidth = screenWidth * 0.4;

    return Center(
      child: Container(
        width: screenWidth * 0.9,
        // padding: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFD2E9FF), Color(0xFFF2E6D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Text(
                'Your Weight Goal',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: glDarkPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  WeightCard(
                    cardWidth: cardWidth,
                    title: 'Current Weight',
                    value: "${DashboardService.to.data.value.currentWeight}",
                    imagePath: 'assets/images/w-machine.png',
                    cardGradient: const [
                      Color(0x00000fff),
                      Color(0x00000fff),
                    ],
                    shadowColor: Colors.white24,
                  ),
                  WeightCard(
                    cardWidth: cardWidth,
                    title: 'Target Weight',
                    value: '${DashboardService.to.data.value.targetWeight}',
                    imagePath: 'assets/images/target-weight.png',
                    cardGradient: const [
                      Color(0x00000fff),
                      Color(0x00000fff),
                    ],
                    shadowColor: Colors.white24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightCard extends StatelessWidget {
  final double cardWidth;
  final String title;
  final String value;
  final String imagePath;
  final List<Color> cardGradient;
  final Color shadowColor;

  const WeightCard({
    super.key,
    required this.cardWidth,
    required this.title,
    required this.value,
    required this.imagePath,
    required this.cardGradient,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 20,
      shadowColor: shadowColor,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
