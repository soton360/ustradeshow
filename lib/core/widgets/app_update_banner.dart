import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/app_update_service.dart';

/// Beautiful inline top banner widget displayed right below the AppBar
/// when a new version of the app is available on the Store.
class AppUpdateBanner extends StatelessWidget {
  final UpdateResult updateResult;
  final VoidCallback onUpdate;

  const AppUpdateBanner({
    super.key,
    required this.updateResult,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFEF3F2),
            Color(0xFFEFF6FF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.usaRedBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Glowing System Update Icon Badge
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.usaRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.usaRed.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.system_update_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),

          // 2. Banner Text: "New update available | Version 1.0.1"
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(
                    text: 'New update available',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: '  |  ',
                    style: TextStyle(
                      color: AppColors.borderDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Version ${updateResult.latestVersion}',
                    style: const TextStyle(
                      color: AppColors.usaRed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 3. Styled Update Button (No Cross Button)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.usaRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onUpdate,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
