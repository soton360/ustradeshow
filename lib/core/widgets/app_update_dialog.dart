import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/app_update_service.dart';

/// Modal dialog prompting the user to update the app when a new version
/// is available on Google Play Store.
class AppUpdateDialog extends StatelessWidget {
  final UpdateResult updateResult;
  final VoidCallback onUpdate;
  final VoidCallback? onDismiss;

  const AppUpdateDialog({
    super.key,
    required this.updateResult,
    required this.onUpdate,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required UpdateResult updateResult,
    required VoidCallback onUpdate,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: !updateResult.isForceUpdate,
      builder: (ctx) => PopScope(
        canPop: !updateResult.isForceUpdate,
        child: AppUpdateDialog(
          updateResult: updateResult,
          onUpdate: onUpdate,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 12,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated / Styled Update Icon Header
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryNavy, AppColors.accentBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryNavy.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),

                // Notice Title (Bilingual)
                const Text(
                  'New Update Available!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'নতুন ভার্সন পাওয়া গেছে!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.usaRed,
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                const Text(
                  'A newer version of the 30th U.S. Trade Show 2026 app is available on Google Play Store with performance improvements and new features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Version Comparison Card
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildVersionItem(
                        label: 'Current / বর্তমান',
                        version: 'v${updateResult.currentVersion}',
                        isCurrent: true,
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: AppColors.borderDark,
                      ),
                      _buildVersionItem(
                        label: 'Latest / নতুন',
                        version: 'v${updateResult.latestVersion}',
                        isCurrent: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Release Notes / What's New Box (if any)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.usaGreenSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.usaGreenBorder),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: AppColors.usaGreen,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Includes security patches, speed optimizations & stable event ticket passes.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.usaGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.usaRed,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.get_app_rounded, size: 22),
                    label: const Text(
                      'Update Now / এখনই আপডেট করুন',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onUpdate();
                    },
                  ),
                ),

                if (!updateResult.isForceUpdate) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onDismiss?.call();
                      },
                      child: const Text(
                        'Remind Me Later / পরে আপডেট করব',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!updateResult.isForceUpdate)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textMuted),
                onPressed: () {
                  Navigator.pop(context);
                  onDismiss?.call();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVersionItem({
    required String label,
    required String version,
    required bool isCurrent,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          version,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: isCurrent ? AppColors.textSecondary : AppColors.usaGreen,
          ),
        ),
      ],
    );
  }
}
