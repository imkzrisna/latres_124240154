import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres_mobile/utils/constants.dart';

class FavoriteService {
  static Box get _box => Hive.box(AppConst.favBox);

  static ValueListenable<Box> listenable() => _box.listenable();

  static bool isFavorite(int id) => _box.containsKey(id);

  static Future<void> add(Map<String, dynamic> show) async {
    await _box.put(show['id'] as int, {
      'id': show['id'],
      'name': show['name'] ?? '-',
      'image': (show['image']?['medium'] ?? show['image']?['original'] ?? '')
          as String,
      'rating': show['rating']?['average']?.toString() ?? '-',
    });
  }

  static Future<void> remove(int id) async => _box.delete(id);

  static Future<void> toggle(Map<String, dynamic> show) async {
    final id = show['id'] as int;
    if (isFavorite(id)) {
      await remove(id);
    } else {
      await add(show);
    }
  }

  static List<Map<String, dynamic>> getAll() {
    return _box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
