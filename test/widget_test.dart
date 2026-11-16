import 'package:flutter_test/flutter_test.dart';
import 'package:latres_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(loggedIn: false));
    expect(find.text('Login'), findsOneWidget);
  });
}
