import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/app_update_service.dart';
import '../controllers/registration_controller.dart';
import '../controllers/seminar_controller.dart';
import '../widgets/compact_event_header.dart';
import '../widgets/event_overview_card.dart';
import '../widgets/registration_form_card.dart';
import 'registration_success_screen.dart';
import '../../../ticket/presentation/screens/saved_tickets_screen.dart';

/// Main registration screen for U.S. Trade Show 2026.
/// Single-page, zero-friction visitor flow without tab bars.
class RegistrationScreen extends StatefulWidget {
  final RegistrationController regController;
  final SeminarController semController;

  const RegistrationScreen({
    super.key,
    required this.regController,
    required this.semController,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
    // Pre-fetch seminars quietly in background & check for app updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.semController.fetchSeminars();
      AppUpdateService.instance.checkForUpdateAndPrompt(context);
    });
  }

  void _navigateToSuccess() {
    final response = widget.regController.lastResponse;
    if (response == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationSuccessScreen(
          response: response,
          onRegisterAnother: () {
            widget.regController.resetForm();
            widget.semController.clearSelection();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showEventDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Event Details & Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            const Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: EventOverviewCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: const Icon(
                Icons.business_center_rounded,
                color: AppColors.primaryNavy,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'U.S. Trade Show 2026',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Check for Updates',
            icon: const Icon(
              Icons.system_update_rounded,
              color: AppColors.primaryNavy,
            ),
            onPressed: () {
              AppUpdateService.instance.checkForUpdateAndPrompt(
                context,
                isManualCheck: true,
              );
            },
          ),
          IconButton(
            tooltip: 'Event Guide & Details',
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryNavy,
            ),
            onPressed: () => _showEventDetailsSheet(context),
          ),
          IconButton(
            tooltip: 'View My Tickets',
            icon: const Icon(
              Icons.confirmation_number_outlined,
              color: AppColors.primaryNavy,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SavedTicketsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 980;

            if (isDesktop) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side: Event info
                            const Expanded(
                              flex: 5,
                              child: EventOverviewCard(),
                            ),
                            const SizedBox(width: 24),
                            // Right side: Registration Form
                            Expanded(
                              flex: 6,
                              child: RegistrationFormCard(
                                regController: widget.regController,
                                semController: widget.semController,
                                onSuccess: _navigateToSuccess,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Mobile & Tablet Portrait: Clean Single Scrollable View
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Compact Hero Header with quick-info & guide button
                  CompactEventHeader(
                    onOpenGuide: () => _showEventDetailsSheet(context),
                  ),
                  const SizedBox(height: 14),

                  // The Main Registration Form - Immediately available to visitor
                  RegistrationFormCard(
                    regController: widget.regController,
                    semController: widget.semController,
                    onSuccess: _navigateToSuccess,
                  ),
                  const SizedBox(height: 24),

                  // Footer
                  _buildFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: const [
        Text(
          '30th U.S. Trade Show 2026 · 5–7 November 2026 · InterContinental Dhaka',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          AppStrings.website,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.accentBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
