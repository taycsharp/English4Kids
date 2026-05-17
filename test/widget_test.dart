import 'package:flutter_test/flutter_test.dart';
import 'package:happy_english_kids/app.dart';

void main() {
  testWidgets('Happy English Kids app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const HappyEnglishKidsApp());

    expect(find.text('Happy English Kids'), findsWidgets);
  });
}
