import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Premium Visitor Pass Type Selector with VIP badge styling.
class TicketTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const TicketTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Visitor pass',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.usaGreenSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.usaGreenBorder, width: 0.8),
              ),
              child: const Text(
                '100% Free Entry',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.usaGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildPassOption(
              title: 'Day visitor',
              subtitle: 'Visit on any 1 chosen exhibition day',
              type: 'day_visitor',
              icon: Icons.calendar_today_rounded,
              badgeText: 'Single Day',
              isSelected: selectedType == 'day_visitor',
            ),
            const SizedBox(height: 10),
            _buildPassOption(
              title: 'Entire 3–day pass',
              subtitle: 'Unlimited access across 5, 6 and 7 November',
              type: 'entire_days_visitor',
              icon: Icons.stars_rounded,
              badgeText: '★ Recommended',
              isRecommended: true,
              isSelected: selectedType == 'entire_days_visitor',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassOption({
    required String title,
    required String subtitle,
    required String type,
    required IconData icon,
    required String badgeText,
    required bool isSelected,
    bool isRecommended = false,
  }) {
    return InkWell(
      onTap: () => onChanged(type),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accentBlue : AppColors.border,
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryNavy
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w700,
                            color: isSelected
                                ? AppColors.primaryNavy
                                : AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isRecommended
                              ? const Color(0xFFFEF3F2)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isRecommended
                                ? AppColors.usaRed
                                : AppColors.accentBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Custom Radio Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.accentBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.accentBlue : AppColors.borderDark,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
