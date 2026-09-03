import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_mobile/app.dart';

void main() {
  testWidgets('App shows a loading spinner before session restore completes', (WidgetTester tester) async {
    await tester.pumpWidget(const CosplayInventoryApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
