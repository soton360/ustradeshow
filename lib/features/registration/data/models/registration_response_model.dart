import 'ticket_model.dart';

/// Full visitor registration response data.
class RegistrationData {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String company;
  final String? designation;
  final int fairId;
  final String status;
  final String visitorType;
  final TicketModel? ticket;
  final List<TicketModel> tickets;
  final List<RegisteredSeminarModel> seminars;

  const RegistrationData({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.company,
    this.designation,
    this.fairId = 1,
    this.status = 'active',
    this.visitorType = 'online',
    this.ticket,
    this.tickets = const [],
    this.seminars = const [],
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    TicketModel? primaryTicket;
    if (json['ticket'] != null && json['ticket'] is Map<String, dynamic>) {
      primaryTicket = TicketModel.fromJson(json['ticket'] as Map<String, dynamic>);
    }

    final ticketList = <TicketModel>[];
    if (json['tickets'] != null && json['tickets'] is List) {
      for (final t in json['tickets']) {
        if (t is Map<String, dynamic>) {
          ticketList.add(TicketModel.fromJson(t));
        }
      }
    }

    final seminarList = <RegisteredSeminarModel>[];
    if (json['seminars'] != null && json['seminars'] is List) {
      for (final s in json['seminars']) {
        if (s is Map<String, dynamic>) {
          seminarList.add(RegisteredSeminarModel.fromJson(s));
        }
      }
    }

    return RegistrationData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      company: json['company']?.toString() ?? '',
      designation: json['designation']?.toString(),
      fairId: json['fair_id'] is int ? json['fair_id'] : 1,
      status: json['status']?.toString() ?? 'active',
      visitorType: json['visitor_type']?.toString() ?? 'online',
      ticket: primaryTicket ?? (ticketList.isNotEmpty ? ticketList.first : null),
      tickets: ticketList,
      seminars: seminarList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'designation': designation,
      'fair_id': fairId,
      'status': status,
      'visitor_type': visitorType,
      'ticket': ticket?.toJson(),
      'tickets': tickets.map((t) => t.toJson()).toList(),
      'seminars': seminars.map((s) => s.toJson()).toList(),
    };
  }
}

/// Root response wrapper from registration API.
class RegistrationResponseModel {
  final bool success;
  final String message;
  final String? token;
  final RegistrationData data;

  const RegistrationResponseModel({
    required this.success,
    required this.message,
    this.token,
    required this.data,
  });

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? 'Visitor registered successfully',
      token: json['token']?.toString(),
      data: RegistrationData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}

