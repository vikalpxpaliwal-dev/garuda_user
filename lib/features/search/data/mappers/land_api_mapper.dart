import 'package:garuda_user_app/features/search/data/models/land_model.dart';

/// Normalizes raw land API payloads before [LandModel] JSON deserialization.
abstract final class LandApiMapper {
  static Map<String, dynamic> prepareLandJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    if (normalized['landDetails'] is Map<String, dynamic>) {
      final details = Map<String, dynamic>.from(
        normalized['landDetails'] as Map<String, dynamic>,
      );
      details['trees'] = _treesFromDetails(details);
      normalized['landDetails'] = details;
    }

    if (!normalized.containsKey('tree') || normalized['tree'] is! List) {
      final rootTrees = normalized['trees'];
      if (rootTrees is List) {
        normalized['tree'] = rootTrees;
      }
    }

    return normalized;
  }

  static List<Map<String, dynamic>> _treesFromDetails(
    Map<String, dynamic> json,
  ) {
    for (final treeKey in ['trees', 'tree']) {
      final value = json[treeKey];
      if (value is List) {
        return value
            .whereType<Map<String, dynamic>>()
            .map(Map<String, dynamic>.from)
            .toList();
      }
    }

    const legacyTreeKeys = <String, String>{
      'mango_trees_number': 'Mango',
      'coconut_trees_number': 'Coconut',
      'neem_trees_number': 'Neem',
      'baniyan_trees_number': 'Baniyan',
      'tamarind_trees_number': 'Tamarind',
      'sapoto_trees_number': 'Sapoto',
      'guava_trees_number': 'Guava',
      'teak_trees_number': 'Teak',
      'other_trees_number': 'Other',
    };

    final trees = <Map<String, dynamic>>[];
    for (final entry in legacyTreeKeys.entries) {
      final value = json[entry.key];
      final count = parseTreeCount(value);
      if (count > 0) {
        trees.add({'type': entry.value, 'count': count});
      }
    }
    return trees;
  }

  static int parseTreeCount(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      final match = RegExp(r'\d+').firstMatch(value);
      return int.tryParse(match?.group(0) ?? '') ?? 0;
    }
    return 0;
  }
}
