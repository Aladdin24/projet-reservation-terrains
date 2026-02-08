// lib/services/api_service.dart
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.55.23.68:8000/api';
  // // Android emulator
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get token => _prefs.getString('access_token');

  static Future<dynamic> _request(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$url');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    late http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      default:
        throw Exception('Méthode non supportée');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Token expiré → déconnexion
      _prefs.remove('access_token');
      Get.offAllNamed('/login');
      throw Exception('Session expirée');
    } else {
      final error = jsonDecode(response.body);
      if (error is Map && error.isNotEmpty) {
        final firstKey = error.keys.first;
        final message = error[firstKey];

        if (message is List && message.isNotEmpty) {
          throw Exception(message.first.toString());
        }
        throw Exception(message.toString());
      }

      throw Exception('Erreur serveur');
    }
  }

  // Auth
  static Future<Map<String, dynamic>> login(
    String phone,
    String password,
  ) async {
    final data =
        await _request(
              '/auth/login/',
              method: 'POST',
              body: {'telephone': phone, 'password': password},
            )
            as Map<String, dynamic>;
    await _prefs.setString('access_token', data['access']);
    await _prefs.setInt('user_id', data['user_id']);
    return data;
  }

  static Future<Map<String, dynamic>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final data = await _request(
      '/auth/register/',
      method: 'POST',
      body: {
        'telephone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'password2': password,
      },
    );
    await _prefs.setString('access_token', data['access']);
    await _prefs.setInt('user_id', data['user']['id']);
    return data;
  }

  // Terrains
  static Future<List<dynamic>> getTerrains({
    String? date,
    double? latitude,
    double? longitude,
  }) async {
    String url = '/terrains/';
    final params = <String, String>{};
    if (date != null) params['disponible_le'] = date;
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();

    if (params.isNotEmpty) {
      url += '?' + params.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    final data = await _request(url);
    return List<dynamic>.from(data);
  }

  // Réservation
  static Future<Map<String, dynamic>> createReservation({
    required int creneauId,
    required String type,
    String? groupeId,
    required String methodePaiement,
    required String reference,
  }) async {
    final body = {
      'creneau_id': creneauId,
      'type_reservation': type,
      'methode_paiement': methodePaiement,
      'reference_transaction': reference,
    };
    if (groupeId != null) body['groupe_id'] = int.parse(groupeId);
    return await _request('/reservations/', method: 'POST', body: body);
  }

  // Mes réservations
  static Future<List<dynamic>> getMyReservations() async {
    final data = await _request('/reservations/my-reservations/');
    return List<dynamic>.from(data as Iterable<dynamic>);
  }

  // Évaluation
  static Future<void> submitEvaluation({
    required int terrainId,
    required int note,
    required String commentaire,
  }) async {
    await _handleError(() async {
      await _request(
        '/terrains/evaluations/',
        method: 'POST',
        body: {
          'terrain_id': terrainId,
          'note': note,
          'commentaire': commentaire,
        },
      );
    });
  }

  static Future<void> cancelReservation(int reservationId) async {
    await _request('/reservations/$reservationId/cancel/', method: 'POST');
  }

  static Future<void> _handleError(Function() fn) async {
    try {
      await fn();
    } catch (e) {
      rethrow;
    }
  }
}
