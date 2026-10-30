/// Ticket details model.
class TicketModel {
  final int id;
  final String ticketNo;
  final int visitorId;
  final int fairId;
  final String? ticketDate;
  final String ticketType;
  final String paymentStatus;
  final int totalPax;
  final String? createdAt;

  const TicketModel({
    required this.id,
    required this.ticketNo,
    required this.visitorId,
    required this.fairId,
    this.ticketDate,
    required this.ticketType,
    required this.paymentStatus,
    this.totalPax = 1,
    this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      ticketNo: json['ticket_no']?.toString() ?? 'TKT-PENDING',
      visitorId: json['visitor_id'] is int
          ? json['visitor_id']
          : int.tryParse(json['visitor_id']?.toString() ?? '0') ?? 0,
      fairId: json['fair_id'] is int
          ? json['fair_id']
          : int.tryParse(json['fair_id']?.toString() ?? '1') ?? 1,
      ticketDate: json['ticket_date']?.toString(),
      ticketType: json['ticket_type']?.toString() ?? 'day_visitor',
      paymentStatus: json['payment_status']?.toString() ?? 'free',
      totalPax: json['total_pax'] is int
          ? json['total_pax']
          : int.tryParse(json['total_pax']?.toString() ?? '1') ?? 1,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_no': ticketNo,
      'visitor_id': visitorId,
      'fair_id': fairId,
      'ticket_date': ticketDate,
      'ticket_type': ticketType,
      'payment_status': paymentStatus,
      'total_pax': totalPax,
      'created_at': createdAt,
    };
  }

  String get readablePassType {
    if (ticketType == 'entire_days_visitor') {
      return 'Entire 3-Day Pass';
    }
    return 'Single Day Pass (1 Day)';
  }

  String get paymentDisplay {
    if (paymentStatus.toLowerCase() == 'free') {
      return 'FREE (0 BDT)';
    }
    return '${paymentStatus.toUpperCase()} (0 BDT)';
  }
}

/// Joined seminar confirmation in registration response.
class RegisteredSeminarModel {
  final int id;
  final int seminarId;
  final String title;
  final String slug;
  final String date;
  final String? location;
  final String status;

  const RegisteredSeminarModel({
    required this.id,
    required this.seminarId,
    required this.title,
    required this.slug,
    required this.date,
    this.location,
    required this.status,
  });

  factory RegisteredSeminarModel.fromJson(Map<String, dynamic> json) {
    return RegisteredSeminarModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      seminarId: json['seminar_id'] is int
          ? json['seminar_id']
          : int.tryParse(json['seminar_id']?.toString() ?? '0') ?? 0,
      title: json['seminar_title']?.toString() ?? json['title']?.toString() ?? '',
      slug: json['seminar_slug']?.toString() ?? json['slug']?.toString() ?? '',
      date: json['seminar_date']?.toString() ?? json['date']?.toString() ?? '',
      location: json['seminar_location']?.toString() ?? json['location']?.toString(),
      status: json['status']?.toString() ?? 'approved',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seminar_id': seminarId,
      'seminar_title': title,
      'seminar_slug': slug,
      'seminar_date': date,
      'seminar_location': location,
      'status': status,
    };
  }
}

