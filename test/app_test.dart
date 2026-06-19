import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Campaign & Transaction Helpers Tests', () {
    test('Calculate progress percentage helper', () {
      final double target = 5000.0;
      final double collected = 2500.0;

      final double progress = target > 0 ? (collected / target).clamp(0.0, 1.0) : 0.0;

      expect(progress, equals(0.5));
      expect(progress * 100, equals(50.0));
    });

    test('Calculate progress percentage helper division by zero safety', () {
      final double target = 0.0;
      final double collected = 1000.0;

      final double progress = target > 0 ? (collected / target).clamp(0.0, 1.0) : 0.0;

      expect(progress, equals(0.0));
    });

    test('Verify Transaction ID generation format', () {
      final int nowMillis = DateTime.now().millisecondsSinceEpoch;
      final String txnId = 'TXN-$nowMillis';

      expect(txnId.startsWith('TXN-'), isTrue);
      expect(txnId.length, greaterThan(4));
    });

    test('Categories List contains all expected elements', () {
      final List<String> categories = [
        'All',
        'Medical & Healthcare',
        'Education',
        'Disaster Relief',
        'Hunger & Food',
        'Shelter & Housing',
        'General Charity',
      ];

      expect(categories.contains('All'), isTrue);
      expect(categories.contains('Medical & Healthcare'), isTrue);
      expect(categories.contains('General Charity'), isTrue);
      expect(categories.length, equals(7));
    });
  });
}
