/// Registration request payload sent to AmCham API.
class RegistrationRequestModel {
  final String name;
  final String? phone;
  final String email;
  final String company;
  final String? designation;
  final String ticketType; // 'day_visitor' or 'entire_days_visitor'
  final String? ticketDate; // e.g. '2026-11-06' (only for day_visitor)
  final int totalPax;
  final List<int> seminarIds;

  const RegistrationRequestModel({
    required this.name,
    this.phone,
    required this.email,
    required this.company,
    this.designation,
    required this.ticketType,
    this.ticketDate,
    this.totalPax = 1,
    this.seminarIds = const [],
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'company': company.trim(),
      'ticket_type': ticketType,
      'total_pax': totalPax,
      'seminar_ids': seminarIds,
    };

    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }

    if (designation != null && designation!.trim().isNotEmpty) {
      map['designation'] = designation!.trim();
    }

    if (ticketType == 'day_visitor' && ticketDate != null && ticketDate!.isNotEmpty) {
      map['ticket_date'] = ticketDate;
    }

    return map;
  }
}

