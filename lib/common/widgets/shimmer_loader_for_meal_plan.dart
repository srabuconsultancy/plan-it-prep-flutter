import 'package:flutter/material.dart';

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Container(
            height: 20,
            width: 150,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(bottom: 16),
          ),
          // Breakfast Section
          const ShimmerListSection(
            title: "Breakfast",
            itemCount: 2,
          ),
          const SizedBox(height: 16),
          // Morning Snack Section
          const ShimmerListSection(
            title: "Morning Snack",
            itemCount: 2,
          ),
          const SizedBox(height: 16),
          // Lunch Section
          const ShimmerListSection(
            title: "Lunch",
            itemCount: 1,
          ),
        ],
      ),
    );
  }
}

class ShimmerListSection extends StatelessWidget {
  final String title;
  final int itemCount;

  const ShimmerListSection({
    super.key,
    required this.title,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          height: 20,
          width: 100,
          color: Colors.grey[300],
          margin: const EdgeInsets.only(bottom: 8),
        ),
        // Shimmer Items
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) => const ShimmerListItem(),
        ),
      ],
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          // Details placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                // Info placeholder
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 40,
                      color: Colors.grey[300],
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    Container(
                      height: 14,
                      width: 40,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Action buttons placeholder
          Column(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
