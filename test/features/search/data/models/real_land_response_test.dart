import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/features/search/data/models/land_model.dart';

void main() {
  test('parses every land in the real /buyer/land response', () {
    final raw = File('test/fixtures/buyer_land_response.json').readAsStringSync();
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    expect(decoded['success'], true);

    final data = decoded['data'] as List<dynamic>;
    expect(data, isNotEmpty);

    final failures = <String>[];
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      try {
        final model = LandModel.fromJson(map);
        model.toEntity();
      } catch (error, stack) {
        failures.add('land id=${map['id']}: $error\n$stack');
      }
    }

    expect(
      failures,
      isEmpty,
      reason: 'Failed to parse ${failures.length} lands:\n'
          '${failures.join('\n---\n')}',
    );
  });
}
