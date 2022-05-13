import 'package:appserap/main.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Login -', () {
    testWidgets('Quando o usuario clicar em logar, deve fazer o login', (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(MyApp());
    });
  });
}
