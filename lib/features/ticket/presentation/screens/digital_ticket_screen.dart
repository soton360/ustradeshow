import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/ribbon_bar.dart';
import '../../../../core/widgets/skyline_bottom_decoration.dart';

/// Official digital admission pass matching 100% the AmCham Trade Show email ticket format.
class DigitalTicketScreen extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const DigitalTicketScreen({
    super.key,
    required this.ticketData,
  });

  @override
  Widget build(BuildContext context) {
    final visitor = ticketData['visitor'] as Map<String, dynamic>? ?? {};
    final ticket = ticketData['ticket'] as Map<String, dynamic>? ?? {};
    final seminars = ticketData['seminars'] as List<dynamic>? ?? [];

    final ticketNo = ticket['ticket_no']?.toString() ?? 'TKT-PENDING';
    final isEntireDays =
        ticket['ticket_type']?.toString() == 'entire_days_visitor';
    final passTypeName =
        isEntireDays ? 'Entire 3-Day Pass' : 'Single Day Pass (1 Day)';
    final passTypeDesc = isEntireDays
        ? '(Valid for entrance on all days 5–7 November 2026)'
        : '(Valid for entrance on any single day of the U.S. Trade Show)';

    final visitorName = visitor['name']?.toString() ?? 'Visitor';
    final visitorPhone = visitor['phone']?.toString() ?? 'N/A';
    final visitorEmail = visitor['email']?.toString() ?? 'N/A';
    final company = visitor['company']?.toString() ?? 'N/A';
    final designation = visitor['designation']?.toString() ?? '';
    final companyDisplay =
        designation.isNotEmpty ? '$company ($designation)' : company;

    final paxCount = ticket['total_pax'] is int
        ? ticket['total_pax']
        : int.tryParse(ticket['total_pax']?.toString() ?? '1') ?? 1;
    final paxDisplay = '$paxCount Pax';

    final paymentStatus =
        ticket['payment_status']?.toString().toLowerCase() ?? 'free';
    final paymentDisplay =
        paymentStatus == 'free' ? 'FREE (0 BDT)' : '${paymentStatus.toUpperCase()} (0 BDT)';

    return Scaffold(
      backgroundColor: const Color(0xFF0B192C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Official Admission Pass',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          const SkylineBottomDecoration(
            backgroundColor: Color(0xFF0B192C),
            height: 180,
            opacity: 0.25,
          ),
          SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                children: [
                  // Pass Container (styled exactly like the email document)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Ribbon Accent
                        const RibbonBar(height: 5),

                        // Section 1: Blue Hero Card (matching email header)
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0D253F),
                                Color(0xFF1E3A8A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Centered Official Logo
                              Container(
                                width: 88,
                                height: 88,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  AppAssets.usts2026Logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.business,
                                    size: 44,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Header Pill: 30TH U.S. TRADE SHOW 2026 ENTRY PASS
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  '30TH U.S. TRADE SHOW 2026 ENTRY PASS',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Title
                              const Text(
                                '30th U.S. Trade Show 2026',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Venue & Date Subtitle
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                runSpacing: 4,
                                children: const [
                                  Text(
                                    '📍 InterContinental Dhaka',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '•',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  Text(
                                    '📅 Nov 5, 2026 - Nov 7, 2026',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Section 2: VISITOR DETAILS (Table exactly like email)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VISITOR DETAILS',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildTableRow(
                                      'Visitor Name:',
                                      visitorName,
                                      isBold: true,
                                    ),
                                    const Divider(
                                        height: 1, color: Color(0xFFE2E8F0)),
                                    _buildTableRow(
                                      'Phone:',
                                      visitorPhone,
                                      isLink: true,
                                    ),
                                    const Divider(
                                        height: 1, color: Color(0xFFE2E8F0)),
                                    _buildTableRow(
                                      'Email:',
                                      visitorEmail,
                                      isLink: true,
                                    ),
                                    const Divider(
                                        height: 1, color: Color(0xFFE2E8F0)),
                                    _buildTableRow(
                                      'Company / Org:',
                                      companyDisplay,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Section 3: 3 Stat Cards Row (Pass Type, Persons/Pax, Payment)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatBox(
                                  'PASS TYPE',
                                  passTypeName,
                                  textColor: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatBox(
                                  'PERSONS / PAX',
                                  paxDisplay,
                                  textColor: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatBox(
                                  'PAYMENT',
                                  paymentDisplay,
                                  textColor: AppColors.usaGreen,
                                  isPayment: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),

                        // Section 4: GATE ENTRY QR CODE
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'GATE ENTRY QR CODE',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E40AF),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // QR Code in distinct square border
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF0A2540),
                                    width: 1.8,
                                  ),
                                ),
                                child: QrImageView(
                                  data: ticketNo,
                                  version: QrVersions.auto,
                                  size: 160,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Ticket Number
                              Text(
                                ticketNo,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF0A2540),
                                ),
                              ),
                              const SizedBox(height: 6),

                              const Text(
                                'Please show this QR code at the U.S. Trade Show entrance scanner for instant check-in.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475467),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFE2E8F0)),

                        // Section 5: ENTRY INSTRUCTIONS & GUIDELINES (Verbatim from email)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ENTRY INSTRUCTIONS & GUIDELINES',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildBulletPoint(
                                'Pass Type: $passTypeName $passTypeDesc.',
                              ),
                              _buildBulletPoint(
                                'Admit Capacity: $paxCount person(s) admission.',
                              ),
                              _buildBulletPoint(
                                'QR code encodes your unique ticket ID ($ticketNo) for gate scanning.',
                              ),
                              _buildBulletPoint(
                                'Please have this email/pass ready on your phone or keep a printed copy when arriving at the venue.',
                              ),
                              _buildBulletPoint(
                                'Each ticket is unique and non-transferable. Once scanned, duplicate entry will be rejected.',
                              ),
                            ],
                          ),
                        ),

                        // Section 6: Registered Seminars if any
                        if (seminars.isNotEmpty) ...[
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'REGISTERED SEMINARS (CRYSTAL BALLROOM)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...seminars.map((s) {
                                  final sMap =
                                      s is Map<String, dynamic> ? s : {};
                                  final title = sMap['seminar_title'] ??
                                      sMap['title'] ??
                                      'Seminar';
                                  final date = sMap['seminar_date'] ??
                                      sMap['date'] ??
                                      '';

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          size: 15,
                                          color: AppColors.usaGreen,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '$title ($date)',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],

                        // Section 7: Navy Email Footer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D253F),
                          ),
                          child: Column(
                            children: const [
                              Text(
                                'American Chamber of Commerce in Bangladesh (AmCham)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Need help? Contact U.S. Trade Show support at faysal@amchambd.org',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF93C5FD),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '© 2026 AmCham Bangladesh. All rights reserved.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Close Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  Widget _buildTableRow(String label, String value,
      {bool isBold = false, bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: isLink
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value,
      {required Color textColor, bool isPayment = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475467),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475467),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
