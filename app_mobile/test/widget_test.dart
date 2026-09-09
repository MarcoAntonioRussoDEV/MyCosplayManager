import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_cosplay_manager/app.dart';

void main() {
  testWidgets('App shows a loading spinner before session restore completes', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCosplayManagerApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
