import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Premium Calendar Day Picker for single day visitors.
/// Displays Opening Day (05 Nov), Day 2 (06 Nov), and Closing Day (07 Nov) with elegant styling.
/// Automatically disables past days based on the current date.
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
      'label': 'Opening Day',
      'weekday': 'THU',
      'dayNumber': '05',
      'month': 'NOV 2026',
    },
    {
      'date': '2026-11-06',
      'label': 'Day 2',
      'weekday': 'FRI',
      'dayNumber': '06',
      'month': 'NOV 2026',
    },
    {
      'date': '2026-11-07',
      'label': 'Closing Day',
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Select visit date',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Crystal Ballroom',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 Calendar Cards Row (Opening Day, Day 2, Closing Day)
          Row(
            children: days.map((dayInfo) {
              final isPast = isDatePassed(dayInfo['date']!, currentTime);
              final isSelected = !isPast && selectedDate == dayInfo['date'];
              final label = dayInfo['label']!;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.5),
                  child: Opacity(
                    opacity: isPast ? 0.45 : 1.0,
                    child: InkWell(
                      onTap: isPast
                          ? () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${dayInfo['dayNumber']} Nov 2026 ($label) has already passed. Please select an upcoming date.',
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
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF0A2540),
                                    Color(0xFF1E3A8A)
                                  ],
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
                                  alpha: 0.28,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            else if (!isPast)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Day Event Label Badge (Opening Day, Day 2, Closing Day)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: isPast
                                    ? const Color(0xFFE2E8F0)
                                    : isSelected
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : label == 'Opening Day'
                                            ? AppColors.usaRedSoft
                                            : label == 'Closing Day'
                                                ? AppColors.usaGreenSoft
                                                : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                                border: isSelected || isPast
                                    ? null
                                    : Border.all(
                                        color: label == 'Opening Day'
                                            ? AppColors.usaRedBorder
                                            : label == 'Closing Day'
                                                ? AppColors.usaGreenBorder
                                                : const Color(0xFFBFDBFE),
                                        width: 0.8,
                                      ),
                              ),
                              child: Text(
                                isPast ? 'PASSED' : label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isPast ? 8.5 : 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.1,
                                  color: isPast
                                      ? const Color(0xFF94A3B8)
                                      : isSelected
                                          ? Colors.white
                                          : label == 'Opening Day'
                                              ? AppColors.usaRed
                                              : label == 'Closing Day'
                                                  ? AppColors.usaGreen
                                                  : AppColors.accentBlue,
                                ),
                              ),
                            ),

                            const SizedBox(height: 7),

                            // Large Day Number
                            Text(
                              dayInfo['dayNumber']!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                color: isPast
                                    ? const Color(0xFF94A3B8)
                                    : isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 3),

                            // Month & Weekday
                            Text(
                              isPast
                                  ? 'Closed'
                                  : 'Nov (${dayInfo['weekday']})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isPast
                                    ? const Color(0xFF94A3B8)
                                    : isSelected
                                        ? Colors.white.withValues(alpha: 0.88)
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
                'Daily Exhibition Hours: 10:00 AM – 8:00 PM',
                style: TextStyle(
                  fontSize: 11,
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
