import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable American Chamber & Trade Show 3-color ribbon bar (Navy, Red, Green).
class RibbonBar extends StatelessWidget {
  final double height;
  final BorderRadius? borderRadius;

  const RibbonBar({
    super.key,
    this.height = 4.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        height: height,
        child: Row(
          children: const [
            Expanded(
              flex: 4,
              child: ColoredBox(color: AppColors.primaryNavy),
            ),
            Expanded(
              flex: 4,
              child: ColoredBox(color: AppColors.usaRed),
            ),
            Expanded(
              flex: 4,
              child: ColoredBox(color: AppColors.usaGreen),
            ),
          ],
        ),
      ),
    );
  }
}
