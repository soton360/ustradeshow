import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../widgets/app_update_dialog.dart';

/// Data model representing the result of an update check.
class UpdateResult {
  final bool isUpdateAvailable;
  final String currentVersion;
  final String latestVersion;
  final bool isForceUpdate;
  final String? releaseNotes;
  final String storeUrl;
  final AppUpdateInfo? inAppUpdateInfo;

  const UpdateResult({
    required this.isUpdateAvailable,
    required this.currentVersion,
    required this.latestVersion,
    this.isForceUpdate = false,
    this.releaseNotes,
    required this.storeUrl,
    this.inAppUpdateInfo,
  });
}

/// Service managing Play Store (Android) & App Store (iOS) update checks, prompts, and store navigation.
class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  static const String _prefLastDismissedKey =
      'app_update_last_dismissed_timestamp';

  /// Check if a newer version of the app exists on Google Play Store (Android) or Apple App Store (iOS).
  Future<UpdateResult> checkForUpdate({bool debugSimulate = false}) async {
    String currentVersion = '1.0.0';
    String currentBuild = '1';
    String packageName = 'com.amcham.ustradeshow';

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;
      currentBuild = packageInfo.buildNumber;
      packageName = packageInfo.packageName;
    } catch (e) {
      debugPrint('AppUpdateService: PackageInfo lookup warning: $e');
    }

    final playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    final appStoreUrl = 'https://apps.apple.com/app/id$packageName';

    if (debugSimulate) {
      return UpdateResult(
        isUpdateAvailable: true,
        currentVersion: currentVersion,
        latestVersion: '1.0.2',
        isForceUpdate: false,
        storeUrl: Platform.isIOS ? appStoreUrl : playStoreUrl,
      );
    }

    // 1. Android Platform Specific Update Checks
    if (!kIsWeb && Platform.isAndroid) {
      // 1A. Try Native Android Google Play In-App Update API Check
      try {
        final updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          final availCode = updateInfo.availableVersionCode ?? 0;
          final isImmediateAllowed = updateInfo.immediateUpdateAllowed;
          final isForce = isImmediateAllowed ||
              (availCode > (int.tryParse(currentBuild) ?? 0) + 10);

          return UpdateResult(
            isUpdateAvailable: true,
            currentVersion: currentVersion,
            latestVersion: '$availCode',
            isForceUpdate: isForce,
            storeUrl: playStoreUrl,
            inAppUpdateInfo: updateInfo,
          );
        }
      } catch (e) {
        debugPrint(
            'AppUpdateService: InAppUpdate check skipped or unavailable (expected in debug/sideload): $e');
      }

      // 1B. Fallback Android Play Store Web Check
      try {
        final storeVersion = await _fetchPlayStoreVersion(packageName);
        if (storeVersion != null && storeVersion.isNotEmpty) {
          final isHigher = _isVersionHigher(currentVersion, storeVersion);
          if (isHigher) {
            return UpdateResult(
              isUpdateAvailable: true,
              currentVersion: currentVersion,
              latestVersion: storeVersion,
              isForceUpdate: false,
              storeUrl: playStoreUrl,
            );
          }
        }
      } catch (e) {
        debugPrint('AppUpdateService: Play store scrape check exception: $e');
      }
    }

    // 2. iOS Platform Specific Update Check (iTunes Lookup API)
    if (!kIsWeb && Platform.isIOS) {
      try {
        final appStoreData = await _fetchAppStoreVersion(packageName);
        if (appStoreData != null) {
          final storeVersion = appStoreData['version'] ?? '';
          final storeUrl = appStoreData['storeUrl'] ?? appStoreUrl;

          if (storeVersion.isNotEmpty &&
              _isVersionHigher(currentVersion, storeVersion)) {
            return UpdateResult(
              isUpdateAvailable: true,
              currentVersion: currentVersion,
              latestVersion: storeVersion,
              isForceUpdate: false,
              storeUrl: storeUrl,
            );
          }
        }
      } catch (e) {
        debugPrint('AppUpdateService: iOS App Store check exception: $e');
      }
    }

    return UpdateResult(
      isUpdateAvailable: false,
      currentVersion: currentVersion,
      latestVersion: currentVersion,
      storeUrl: Platform.isIOS ? appStoreUrl : playStoreUrl,
    );
  }

  /// Scrapes the Google Play Store web details page to determine the latest published version.
  Future<String?> _fetchPlayStoreVersion(String packageName) async {
    try {
      final uri = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName&hl=en');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final body = response.body;
        // Regex for version string matching on Google Play page HTML
        final versionRegex = RegExp(r'\[\[\["([0-9]+\.[0-9]+\.[0-9]+)"\]\]');
        final match = versionRegex.firstMatch(body);
        if (match != null && match.groupCount >= 1) {
          return match.group(1);
        }
      }
    } catch (_) {}
    return null;
  }

  /// Queries Apple iTunes Lookup API for official iOS App Store version.
  Future<Map<String, String>?> _fetchAppStoreVersion(String bundleId) async {
    try {
      final uri =
          Uri.parse('https://itunes.apple.com/lookup?bundleId=$bundleId');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is Map &&
            (json['resultCount'] ?? 0) > 0 &&
            json['results'] is List) {
          final result = json['results'][0];
          final version = result['version']?.toString();
          final url = result['trackViewUrl']?.toString();
          if (version != null && version.isNotEmpty) {
            return {
              'version': version,
              'storeUrl': url ?? 'https://apps.apple.com/app/id$bundleId',
            };
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Compares standard semantic versions (e.g. 1.0.1 > 1.0.0).
  bool _isVersionHigher(String current, String latest) {
    try {
      final currentClean = current.split('+')[0];
      final latestClean = latest.split('+')[0];

      final currentParts =
          currentClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final latestParts =
          latestClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < latestParts.length; i++) {
        final curr = i < currentParts.length ? currentParts[i] : 0;
        final lat = latestParts[i];
        if (lat > curr) return true;
        if (lat < curr) return false;
      }
    } catch (_) {}
    return false;
  }

  /// Perform update check and show prompt/dialog if an update is available.
  Future<void> checkForUpdateAndPrompt(
    BuildContext context, {
    bool isManualCheck = false,
  }) async {
    if (!context.mounted) return;

    if (isManualCheck) {
      _showLoadingSnackBar(context);
    }

    final result = await checkForUpdate();

    if (!context.mounted) return;

    if (isManualCheck) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    if (result.isUpdateAvailable) {
      // Respect user dismissal period for non-force updates when running automatic check
      if (!isManualCheck && !result.isForceUpdate) {
        final prefs = await SharedPreferences.getInstance();
        final lastDismissed = prefs.getInt(_prefLastDismissedKey) ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        // Remind after 24 hours
        if (now - lastDismissed < 24 * 60 * 60 * 1000) {
          return;
        }
      }

      // 1. Try Google Play In-App Update flow (Android)
      if (result.inAppUpdateInfo != null && !kIsWeb && Platform.isAndroid) {
        try {
          if (result.isForceUpdate &&
              result.inAppUpdateInfo!.immediateUpdateAllowed) {
            await InAppUpdate.performImmediateUpdate();
            return;
          } else if (result.inAppUpdateInfo!.flexibleUpdateAllowed) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
            return;
          }
        } catch (e) {
          debugPrint(
              'AppUpdateService: InAppUpdate immediate/flexible prompt error: $e');
        }
      }

      // Guard build context before showing dialog
      if (!context.mounted) return;

      // 2. Custom Flutter update notice dialog (Android & iOS)
      AppUpdateDialog.show(
        context,
        updateResult: result,
        onUpdate: () => openStore(result.storeUrl),
        onDismiss: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(
            _prefLastDismissedKey,
            DateTime.now().millisecondsSinceEpoch,
          );
        },
      );
    } else if (isManualCheck) {
      _showUpToDateSnackBar(context, result.currentVersion);
    }
  }

  /// Opens the native Google Play Store (Android) or Apple App Store (iOS).
  Future<bool> openStore(String storeUrl) async {
    // 1. iOS App Store Deep Link (itms-apps://)
    if (!kIsWeb && Platform.isIOS) {
      try {
        final itmsUrl = storeUrl.replaceAll('https://', 'itms-apps://');
        final itmsUri = Uri.parse(itmsUrl);
        if (await canLaunchUrl(itmsUri)) {
          return await launchUrl(itmsUri, mode: LaunchMode.externalApplication);
        }
      } catch (_) {}
    }

    // 2. Android Play Store Market Deep Link (market://)
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final uri = Uri.parse(storeUrl);
        final queryParam = uri.queryParameters['id'];
        if (queryParam != null && queryParam.isNotEmpty) {
          final marketUri = Uri.parse('market://details?id=$queryParam');
          if (await canLaunchUrl(marketUri)) {
            return await launchUrl(marketUri,
                mode: LaunchMode.externalApplication);
          }
        }
      } catch (_) {}
    }

    // 3. Fallback standard HTTPS web URL launch
    try {
      final webUri = Uri.parse(storeUrl);
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('AppUpdateService: Could not launch store URL: $e');
    }
    return false;
  }

  void _showLoadingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Checking for app updates...'),
          ],
        ),
        duration: Duration(seconds: 4),
        backgroundColor: AppColors.primaryNavy,
      ),
    );
  }

  void _showUpToDateSnackBar(BuildContext context, String version) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App is up to date! (v$version)',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'You are using the latest version of the application.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
