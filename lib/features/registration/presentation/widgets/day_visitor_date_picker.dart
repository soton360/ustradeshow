import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Premium Calendar Day Picker for single day visitors.
/// Automatically disables past days based on the current date (e.g. Nov 5 is disabled when today is Nov 6).
class DayVisitorDatePicker extends StatelessWidget {
  final String selectedDate;
  final ValueChanged<String> onDateSelected;
  final DateTime? currentTime;

  const DayVisitorDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.currentTime,
  });

  static const List<Map<String, String>> days = [
    {
      'date': '2026-11-05',
      'weekday': 'THU',
      'dayNumber': '05',
      'month': 'NOV 2026',
    },
    {
      'date': '2026-11-06',
      'weekday': 'FRI',
      'dayNumber': '06',
      'month': 'NOV 2026',
    },
    {
      'date': '2026-11-07',
      'weekday': 'SAT',
      'dayNumber': '07',
      'month': 'NOV 2026',
    },
  ];

  /// Checks if a given exhibition day has already passed relative to [referenceTime].
  static bool isDatePassed(String dateStr, [DateTime? referenceTime]) {
    final now = referenceTime ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayDate = DateTime.parse(dateStr);
    return dayDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Select visit date',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              const Text(
                'Crystal Ballroom',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3 Calendar Cards Row
          Row(
            children: days.map((dayInfo) {
              final isPast = isDatePassed(dayInfo['date']!, currentTime);
              final isSelected = !isPast && selectedDate == dayInfo['date'];

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Opacity(
                    opacity: isPast ? 0.45 : 1.0,
                    child: InkWell(
                      onTap: isPast
                          ? () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${dayInfo['dayNumber']} Nov 2026 has already passed. Please select an upcoming date.',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          : () => onDateSelected(dayInfo['date']!),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFF0A2540), Color(0xFF1E3A8A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isPast
                              ? const Color(0xFFF1F5F9)
                              : isSelected
                                  ? null
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isPast
                                ? const Color(0xFFE2E8F0)
                                : isSelected
                                    ? AppColors.primaryNavy
                                    : AppColors.border,
                            width: isSelected ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primaryNavy.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            else if (!isPast)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Weekday badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isPast
                                    ? const Color(0xFFE2E8F0)
                                    : isSelected
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isPast ? 'PASSED' : dayInfo['weekday']!,
                                style: TextStyle(
                                  fontSize: isPast ? 8.5 : 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: isPast
                                      ? const Color(0xFF94A3B8)
                                      : isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Large Day Number
                            Text(
                              dayInfo['dayNumber']!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                color: isPast
                                    ? const Color(0xFF94A3B8)
                                    : isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Month
                            Text(
                              isPast ? 'Closed' : dayInfo['month']!,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isPast
                                    ? const Color(0xFF94A3B8)
                                    : isSelected
                                        ? Colors.white.withValues(alpha: 0.85)
                                        : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Footer info
          Row(
            children: const [
              Icon(
                Icons.schedule_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 5),
              Text(
                'Daily Show Hours: 10:00 AM – 8:00 PM',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
