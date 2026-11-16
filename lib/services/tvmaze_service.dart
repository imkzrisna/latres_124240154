import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latres_mobile/utils/constants.dart';

class TvmazeService {
  static Future<List<Map<String, dynamic>>> fetchShows() async {
    final res = await http.get(Uri.parse('${AppConst.baseUrl}/shows'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final List data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> fetchDetail(int id) async {
    final res = await http.get(Uri.parse('${AppConst.baseUrl}/shows/$id'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // Helper parsing
  static String imageOf(Map<String, dynamic> s) {
    final img = s['image'];
    if (img == null) return '';
    return (img['medium'] ?? img['original'] ?? '') as String;
  }

  static String imageOriginalOf(Map<String, dynamic> s) {
    final img = s['image'];
    if (img == null) return '';
    return (img['original'] ?? img['medium'] ?? '') as String;
  }

  static String ratingOf(Map<String, dynamic> s) {
    final r = s['rating']?['average'];
    return r == null ? '-' : r.toString();
  }
}
