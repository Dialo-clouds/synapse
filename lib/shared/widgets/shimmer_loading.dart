import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final double height;
  final double borderRadius;
  final EdgeInsets margin;

  const ShimmerCard({
    super.key,
    this.height = 80,
    this.borderRadius = 16,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.04),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int count;
  const ShimmerList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerCard(height: 160, borderRadius: 20),
        ...List.generate(count - 1, (i) => ShimmerCard(height: 80, borderRadius: 16)),
      ],
    );
  }
}