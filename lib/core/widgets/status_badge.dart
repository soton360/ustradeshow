import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable status badge with pulsing or solid dot indicator.
class StatusBadge extends StatefulWidget {
  final String label;
  final Color dotColor;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final bool isPulsing;

  const StatusBadge({
    super.key,
    required this.label,
    this.dotColor = AppColors.usaGreen,
    this.backgroundColor = AppColors.surface,
    this.textColor = AppColors.textPrimary,
    this.borderColor = AppColors.border,
    this.isPulsing = true,
  });

  factory StatusBadge.registrationOpen() {
    return const StatusBadge(
      label: 'Registration open',
      dotColor: Color(0xFF12B76A),
      backgroundColor: AppColors.surface,
      borderColor: AppColors.border,
      textColor: AppColors.textPrimary,
      isPulsing: true,
    );
  }

  factory StatusBadge.success({required String label}) {
    return StatusBadge(
      label: label,
      dotColor: AppColors.usaGreen,
      backgroundColor: AppColors.usaGreenSoft,
      borderColor: AppColors.usaGreenBorder,
      textColor: AppColors.usaGreen,
      isPulsing: false,
    );
  }

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isPulsing ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.dotColor,
                    shape: BoxShape.circle,
                    boxShadow: widget.isPulsing
                        ? [
                            BoxShadow(
                              color: widget.dotColor.withValues(alpha: 0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
