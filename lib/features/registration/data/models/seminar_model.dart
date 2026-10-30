/// Seminar model representing conference sessions.
class Seminar {
  final int id;
  final int fairId;
  final String title;
  final String slug;
  final String description;
  final String date;
  final String? location;
  final String status;
  final DateTime? createdAt;
  final int totalAttendees;

  const Seminar({
    required this.id,
    required this.fairId,
    required this.title,
    required this.slug,
    required this.description,
    required this.date,
    this.location,
    required this.status,
    this.createdAt,
    this.totalAttendees = 0,
  });

  factory Seminar.fromJson(Map<String, dynamic> json) {
    return Seminar(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      fairId: json['fair_id'] is int ? json['fair_id'] : int.tryParse(json['fair_id']?.toString() ?? '1') ?? 1,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: json['date']?.toString() ?? 'Day and time to be announced',
      location: json['location']?.toString(),
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      totalAttendees: json['total_attendees'] is int
          ? json['total_attendees']
          : int.tryParse(json['total_attendees']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fair_id': fairId,
      'title': title,
      'slug': slug,
      'description': description,
      'date': date,
      'location': location,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'total_attendees': totalAttendees,
    };
  }

  Seminar copyWith({
    int? id,
    int? fairId,
    String? title,
    String? slug,
    String? description,
    String? date,
    String? location,
    String? status,
    DateTime? createdAt,
    int? totalAttendees,
  }) {
    return Seminar(
      id: id ?? this.id,
      fairId: fairId ?? this.fairId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      totalAttendees: totalAttendees ?? this.totalAttendees,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Seminar && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

