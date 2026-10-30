import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local offline storage for visitor registration tickets and tokens.
class LocalTicketStorage {
  static const String _keyTickets = 'saved_visitor_tickets';
  static const String _keyLatestTicket = 'latest_visitor_ticket';
  static const String _keyAuthToken = 'visitor_jwt_token';
  static const String _keySavedProfile = 'visitor_saved_profile';

  static Future<void> saveTicket(Map<String, dynamic> ticketData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLatestTicket, jsonEncode(ticketData));

    final existingListJson = prefs.getStringList(_keyTickets) ?? [];
    existingListJson.insert(0, jsonEncode(ticketData));
    await prefs.setStringList(_keyTickets, existingListJson);
  }

  static Future<Map<String, dynamic>?> getLatestTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLatestTicket);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyTickets) ?? [];
    final results = <Map<String, dynamic>>[];
    for (final item in list) {
      try {
        results.add(jsonDecode(item) as Map<String, dynamic>);
      } catch (_) {}
    }
    return results;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  static Future<void> saveProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySavedProfile, jsonEncode(profile));
  }

  static Future<Map<String, dynamic>?> getSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keySavedProfile);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTickets);
    await prefs.remove(_keyLatestTicket);
    await prefs.remove(_keyAuthToken);
  }
}

