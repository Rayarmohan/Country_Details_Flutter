import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rayar_flutter_app/main.dart';

void main() {
  testWidgets('App launches and shows country list', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CountryExplorerApp()));
    expect(find.text('Countries'), findsOneWidget);
  });
}
