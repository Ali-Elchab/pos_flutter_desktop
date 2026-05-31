import 'package:flutter_test/flutter_test.dart';
import 'package:pos_flutter_desktop/app/app.dart';

void main() {
  testWidgets('shows the POS app shell placeholder', (tester) async {
    await tester.pumpWidget(const PosApp());

    expect(find.text('POS Desktop'), findsOneWidget);
  });
}
