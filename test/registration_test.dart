import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:ustradeshow/core/utils/validators.dart';
import 'package:ustradeshow/features/registration/data/models/registration_request_model.dart';
import 'package:ustradeshow/features/registration/data/models/registration_response_model.dart';
import 'package:ustradeshow/features/registration/data/models/seminar_model.dart';
import 'package:ustradeshow/features/registration/presentation/widgets/day_visitor_date_picker.dart';

void main() {
  group('Exhibition Date Disabling Tests', () {
    test('On Nov 5 (Day 1), all 3 days are available and none is passed', () {
      final nov5 = DateTime(2026, 11, 5, 10, 0);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-05', nov5), isFalse);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-06', nov5), isFalse);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-07', nov5), isFalse);
    });

    test('On Nov 6 (Day 2), Nov 5 is disabled (passed), Nov 6 & 7 are active', () {
      final nov6 = DateTime(2026, 11, 6, 9, 30);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-05', nov6), isTrue); // Disabled!
      expect(DayVisitorDatePicker.isDatePassed('2026-11-06', nov6), isFalse);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-07', nov6), isFalse);
    });

    test('On Nov 7 (Day 3), Nov 5 and Nov 6 are disabled, Nov 7 is active', () {
      final nov7 = DateTime(2026, 11, 7, 14, 0);
      expect(DayVisitorDatePicker.isDatePassed('2026-11-05', nov7), isTrue); // Disabled!
      expect(DayVisitorDatePicker.isDatePassed('2026-11-06', nov7), isTrue); // Disabled!
      expect(DayVisitorDatePicker.isDatePassed('2026-11-07', nov7), isFalse);
    });
  });
  group('Email and Phone Validators Tests', () {
    test('Validates proper email formats and rejects invalid ones', () {
      expect(Validators.validateEmail('soton.m360ict@gmail.com'), isNull);
      expect(Validators.validateEmail('info@amchambd.org'), isNull);
      expect(Validators.validateEmail('john.doe@state.gov'), isNull);

      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('   '), isNotNull);
      expect(Validators.validateEmail('soton'), isNotNull);
      expect(Validators.validateEmail('soton@'), isNotNull);
      expect(Validators.validateEmail('soton@gmail'), isNotNull);
      expect(Validators.validateEmail('soton@.com'), isNotNull);
      expect(Validators.validateEmail('soton@gmail..com'), isNotNull);
    });

    test('Validates phone numbers requiring country code when entered', () {
      expect(Validators.validatePhone('+8801518606399'), isNull);
      expect(Validators.validatePhone('+12025550143'), isNull);

      // When optional, empty string is valid
      expect(Validators.validatePhone('', isRequired: false), isNull);
      expect(Validators.validatePhone(null, isRequired: false), isNull);

      // But when entered with invalid format or without country code, it is rejected
      expect(Validators.validatePhone('123'), isNotNull);
      expect(Validators.validatePhone('notanumber'), isNotNull);
    });
  });
  group('PhoneNumber Integration Tests', () {
    test('PhoneNumber parses BD number and outputs international format', () {
      const phone = PhoneNumber(isoCode: IsoCode.BD, nsn: '1518606399');
      expect(phone.isValid(), isTrue);
      expect(phone.countryCode, '880');
      expect(phone.nsn, '1518606399');
      expect('+${phone.countryCode}${phone.nsn}', '+8801518606399');
    });

    test('PhoneNumber parses leading 0 for BD number correctly', () {
      final parsed = PhoneNumber.parse('01518606399', destinationCountry: IsoCode.BD);
      expect(parsed.isValid(), isTrue);
      expect(parsed.countryCode, '880');
      expect(parsed.nsn, '1518606399');
      expect('+${parsed.countryCode}${parsed.nsn}', '+8801518606399');
    });

    test('PhoneNumber parses with +880 correctly', () {
      final parsed = PhoneNumber.parse('+8801518606399');
      expect(parsed.isValid(), isTrue);
      expect(parsed.isoCode, IsoCode.BD);
      expect(parsed.countryCode, '880');
      expect(parsed.nsn, '1518606399');
      expect('+${parsed.countryCode}${parsed.nsn}', '+8801518606399');
    });

    test('Formats phone properly for API payload with country code', () {
      const phone = PhoneNumber(isoCode: IsoCode.BD, nsn: '1518606399');
      var nsn = phone.nsn.trim().replaceAll(RegExp(r'\D'), '');
      if (nsn.startsWith('0')) {
        nsn = nsn.replaceFirst(RegExp(r'^0+'), '');
      }
      final payloadPhone = '+${phone.countryCode}$nsn';
      expect(payloadPhone, '+8801518606399');
    });
  });
  group('Seminar Model Tests', () {
    test('Correctly parses Seminar JSON from AmCham API', () {
      final json = {
        'id': 4,
        'fair_id': 1,
        'title': 'Energy Security',
        'slug': 'energy-security',
        'description':
            'Powering Bangladesh’s Next Growth Chapter: A Pathway to Energy Security and Stability',
        'date': 'Day and time to be announced',
        'location': null,
        'status': 'active',
        'created_at': '2026-10-27T14:30:46.848Z',
        'total_attendees': 254
      };

      final seminar = Seminar.fromJson(json);
      expect(seminar.id, 4);
      expect(seminar.fairId, 1);
      expect(seminar.title, 'Energy Security');
      expect(seminar.totalAttendees, 254);
    });
  });

  group('Registration Payload Tests', () {
    test('Constructs day visitor payload properly', () {
      const request = RegistrationRequestModel(
        name: 'Soton Ahmed',
        phone: '+8801518606399',
        email: 'soton.m360ict@gmail.com',
        company: 'M360 ICT',
        designation: 'Designation',
        ticketType: 'day_visitor',
        ticketDate: '2026-11-06',
        totalPax: 1,
        seminarIds: [4, 3, 2],
      );

      final json = request.toJson();
      expect(json['name'], 'Soton Ahmed');
      expect(json['ticket_type'], 'day_visitor');
      expect(json['ticket_date'], '2026-11-06');
      expect(json['seminar_ids'], [4, 3, 2]);
    });

    test('Constructs entire 3-day pass payload without ticket_date', () {
      const request = RegistrationRequestModel(
        name: 'Soton Ahmed',
        phone: '+8801518606398',
        email: 'soton@gmail.com',
        company: 'M360 ICT',
        designation: 'Designation',
        ticketType: 'entire_days_visitor',
        totalPax: 1,
        seminarIds: [4],
      );

      final json = request.toJson();
      expect(json['ticket_type'], 'entire_days_visitor');
      expect(json.containsKey('ticket_date'), false);
    });
  });

  group('Registration Response Tests', () {
    test('Correctly parses visitor registration response with ticket and seminars', () {
      final json = {
        'success': true,
        'message':
            'Visitor registered, ticket issued and seminar(s) joined successfully',
        'token': 'sample_jwt_token',
        'data': {
          'id': 459,
          'name': 'Soton Ahmed',
          'email': 'soton.m360ict@gmail.com',
          'phone': '+8801518606399',
          'company': 'M360 ICT',
          'designation': 'Designation',
          'fair_id': 1,
          'status': 'active',
          'ticket': {
            'id': 459,
            'ticket_no': 'TKT-202610459',
            'visitor_id': 459,
            'fair_id': 1,
            'ticket_date': '2026-11-06T00:00:00.000Z',
            'ticket_type': 'day_visitor',
            'payment_status': 'free',
            'total_pax': 1
          },
          'seminars': [
            {
              'id': 793,
              'fair_id': 1,
              'seminar_id': 4,
              'seminar_title': 'Energy Security',
              'seminar_slug': 'energy-security',
              'seminar_date': 'Day and time to be announced',
              'status': 'approved'
            }
          ]
        }
      };

      final response = RegistrationResponseModel.fromJson(json);
      expect(response.success, true);
      expect(response.token, 'sample_jwt_token');
      expect(response.data.id, 459);
      expect(response.data.ticket?.ticketNo, 'TKT-202610459');
      expect(response.data.ticket?.readablePassType, 'Single Day Pass (1 Day)');
      expect(response.data.ticket?.paymentDisplay, 'FREE (0 BDT)');
      expect(response.data.seminars.length, 1);
      expect(response.data.seminars.first.title, 'Energy Security');
    });
  });
}

