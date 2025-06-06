// lib/data/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ta_mobile_ayas/models/character_model.dart';
import 'package:ta_mobile_ayas/models/organization_model.dart';
import 'package:ta_mobile_ayas/models/titan_model.dart';

class ApiService {
  final String _baseUrl = "https://api.attackontitanapi.com";

  // Helper function untuk mengambil data dari API dan menangani error umum
  Future<Map<String, dynamic>> _fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load data from $endpoint. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server for $endpoint: $e');
    }
  }

  // --- Character Services ---
  Future<List<Character>> getAllCharacters({int page = 1}) async {
    final data = await _fetchData('/characters?page=$page');
    final List<dynamic> results = data['results'];
    return results.map((json) => Character.fromJson(json)).toList();
  }

  Future<Character> getCharacterById(int id) async {
    final data = await _fetchData('/characters/$id');
    return Character.fromJson(data);
  }

  // --- Titan Services ---
  Future<List<Titan>> getAllTitans({int page = 1}) async {
    final data = await _fetchData('/titans?page=$page');
    final List<dynamic> results = data['results'];
    return results.map((json) => Titan.fromJson(json)).toList();
  }

  Future<Titan> getTitanById(int id) async {
    final data = await _fetchData('/titans/$id');
    return Titan.fromJson(data);
  }

  // --- Organization Services ---
  Future<List<Organization>> getAllOrganizations({int page = 1}) async {
    final data = await _fetchData('/organizations?page=$page');
    final List<dynamic> results = data['results'];
    return results.map((json) => Organization.fromJson(json)).toList();
  }

  // API tidak menyediakan endpoint untuk detail organisasi tunggal secara eksplisit
  // Jika diperlukan, Anda mungkin perlu mengambil dari daftar atau API menyediakan cara lain
  // Future<Organization> getOrganizationById(int id) async {
  //   final data = await _fetchData('/organizations/$id');
  //   return Organization.fromJson(data);
  // }
  // --- FUNGSI BARU UNTUK MENDAPATKAN RUTE ---
  // Ganti YOUR_Maps_API_KEY dengan API key Anda
  final String _googleMapsApiKey = "AIzaSyBUobs8A5T2-VzFBw0Yf8N7FF5u_4-75P0";

  Future<String> getDirections(
      double startLat, double startLng, double endLat, double endLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$_googleMapsApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      // Ambil encoded polyline dari respons
      if (decodedResponse['routes'] != null &&
          decodedResponse['routes'].isNotEmpty) {
        return decodedResponse['routes'][0]['overview_polyline']['points'];
      }
      return ""; // Kembalikan string kosong jika tidak ada rute
    } else {
      throw Exception('Gagal mendapatkan arahan dari Google Directions API');
    }
  }
}
