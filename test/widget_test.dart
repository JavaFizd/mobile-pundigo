import 'package:flutter_test/flutter_test.dart';
import 'package:pundigo/main.dart';

void main() {
  testWidgets('PundiGo smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PundiGoApp());
    expect(find.text('PundiGo!'), findsWidgets);
  });
}
