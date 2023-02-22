import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  setUp(() {
    Hive.init('database');
  });
  test('Name Box', () async {
    var box = await Hive.openBox<String>('data');

    for (var i = 0; i < 100; i++) {
      box.add('flutter $i');
    }

    expect(box.values.first, 'flutter');
  });

  test('Name Box Put Items', () async {
    var box = await Hive.openBox<String>('demos');
    List<MapEntry<String, String>> items = List.generate(
        100, (index) => MapEntry('$index - $index', 'flutter $index'));
    await box.putAll(Map.fromEntries(items));

    expect(box.get('31 - 31'), 'flutter 31');
  });
}

class Model {
  final String name;
  final String id;

  Model({
    required this.id,
    required this.name,
  });
}
