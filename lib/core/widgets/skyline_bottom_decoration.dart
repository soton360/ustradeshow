import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

/// Reusable background widget that seamlessly blends the U.S. Trade Show skyline
/// graphic at the bottom of any screen with a smooth gradient fade.
class SkylineBottomDecoration extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double opacity;

  const SkylineBottomDecoration({
    super.key,
    this.backgroundColor = const Color(0xFFF0F4F8),
    this.height = 150,
    this.opacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              // 1. Skyline Background Image
              Opacity(
                opacity: opacity,
                child: Image.asset(
                  AppAssets.skyline,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

              // 2. Smooth Top-to-Bottom Gradient Blend with Screen Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0.75),
                      backgroundColor.withValues(alpha: 0.15),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
