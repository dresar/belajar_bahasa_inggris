import 'package:flutter_test/flutter_test.dart';
import 'package:belajar_bahasa_inggris/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EnglishLearningApp());
    expect(find.text('KELAS 1'), findsOneWidget);
  });
}
