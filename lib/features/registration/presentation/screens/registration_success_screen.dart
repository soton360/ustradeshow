import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/ribbon_bar.dart';
import '../../../../core/widgets/skyline_bottom_decoration.dart';
import '../../data/models/registration_response_model.dart';
import '../../../ticket/presentation/screens/digital_ticket_screen.dart';

/// Screen displayed right after successful visitor registration.
/// Exactly follows the layout and styling in the AmCham U.S. Trade Show 2026 portal.
class RegistrationSuccessScreen extends StatefulWidget {
  final RegistrationResponseModel response;
  final VoidCallback onRegisterAnother;

  const RegistrationSuccessScreen({
    super.key,
    required this.response,
    required this.onRegisterAnother,
  });

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openDigitalTicket() {
    final data = widget.response.data;
    final ticket = data.ticket;
    if (ticket == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DigitalTicketScreen(
          ticketData: {
            'visitor': {
              'name': data.name,
              'email': data.email,
              'phone': data.phone,
              'company': data.company,
              'designation': data.designation,
            },
            'ticket': ticket.toJson(),
            'seminars': data.seminars.map((s) => s.toJson()).toList(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.response.data;
    final ticket = data.ticket;
    final isDayPass = ticket?.ticketType == 'day_visitor';

    String visitDateFormatted = '5, 6 and 7 November 2026';
    if (isDayPass && ticket?.ticketDate != null) {
      final parsed = DateFormatter.tryParse(ticket!.ticketDate!);
      if (parsed != null) {
        visitDateFormatted = DateFormatter.formatDisplayDate(parsed);
      } else {
        visitDateFormatted = ticket.ticketDate!;
      }
    }

    final seminarNames = data.seminars.isNotEmpty
        ? data.seminars.map((s) => s.title).join(', ')
        : 'None selected';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const SkylineBottomDecoration(
            backgroundColor: AppColors.background,
            height: 160,
            opacity: 0.35,
          ),
          SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Ribbon Bar
                    const RibbonBar(
                      height: 4,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: [
                          // Animated Checkmark Icon
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE6F4EA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Color(0xFF137333),
                                size: 36,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Heading
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                const Text(
                                  AppStrings.registrationSuccessful,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryNavy,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Thank you, ${data.name}. Your visitor registration is confirmed.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Email Notification Card (Soft Blue Box)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F5FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD0E1FD),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.mail_outline_rounded,
                                  color: Color(0xFF1E40AF),
                                  size: 26,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  AppStrings.checkEmailForTicket,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF3B5998),
                                      height: 1.45,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'Your admission ticket has been sent to '),
                                      TextSpan(
                                        text: data.email,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E3A8A),
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            '.\nPlease check your Inbox, including your Spam or Junk folder, and keep your ticket ready to present at the venue.',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Ticket Details Summary (Aligned 100% with official email confirmation)
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow(
                                  'Visitor Name',
                                  data.name,
                                ),
                                if (data.phone != null &&
                                    data.phone!.trim().isNotEmpty) ...[
                                  const Divider(
                                      height: 18, color: AppColors.borderLight),
                                  _buildSummaryRow(
                                    'Phone',
                                    data.phone!,
                                  ),
                                ],
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Email',
                                  data.email,
                                ),
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Company / Org',
                                  (data.designation != null &&
                                          data.designation!.trim().isNotEmpty)
                                      ? '${data.company} (${data.designation!.trim()})'
                                      : data.company,
                                ),
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Pass Type',
                                  ticket?.readablePassType ??
                                      'Single Day Pass (1 Day)',
                                ),
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Persons / Pax',
                                  '${ticket?.totalPax ?? 1} Pax',
                                ),
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Payment',
                                  ticket?.paymentDisplay ?? 'FREE (0 BDT)',
                                ),
                                if (isDayPass) ...[
                                  const Divider(
                                      height: 18, color: AppColors.borderLight),
                                  _buildSummaryRow(
                                    'Visit date',
                                    visitDateFormatted,
                                  ),
                                ],
                                const Divider(
                                    height: 18, color: AppColors.borderLight),
                                _buildSummaryRow(
                                  'Seminars',
                                  seminarNames,
                                  isLongText: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Interactive Digital Admission Pass Card
                          if (ticket != null) ...[
                            InkWell(
                              onTap: _openDigitalTicket,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.borderLight,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: QrImageView(
                                          data: ticket.ticketNo,
                                          version: QrVersions.auto,
                                          size: 60,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.usaGreenSoft,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'CONFIRMED',
                                                  style: TextStyle(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.usaGreen,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ticket.ticketNo,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'monospace',
                                                  color: AppColors.primaryNavy,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Official Entry Badge Ready',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Tap to view and present at gate',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15,
                                      color: AppColors.textMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Primary Action: View Digital Pass
                          if (ticket != null) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryNavy,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadowColor: AppColors.primaryNavy
                                      .withValues(alpha: 0.25),
                                ),
                                onPressed: _openDigitalTicket,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.confirmation_number_outlined,
                                      size: 19,
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'View Digital Admission Pass',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, size: 17),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Secondary Action: Register another visitor (Centered AmCham style link)
                          Center(
                            child: InkWell(
                              onTap: widget.onRegisterAnother,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.person_add_alt_1_rounded,
                                      size: 17,
                                      color: AppColors.accentBlue,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Register another visitor',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentBlue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.accentBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Footer Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(24)),
                        border: Border(
                          top: BorderSide(
                              color: AppColors.borderLight, width: 1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '30th U.S. Trade Show 2026 · 5–7 November 2026 · InterContinental Dhaka · ${AppStrings.website}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isLongText = false,
  }) {
    if (isLongText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
