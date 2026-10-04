import 'package:flutter_test/flutter_test.dart';

import 'package:vital_sense/main.dart';

void main() {
  testWidgets('VitalSense app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const VitalSenseApp());

    // Wait for the loading state to finish.
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('VitalSense'), findsOneWidget);
    expect(find.text('Current Measurements'), findsOneWidget);
    expect(find.text('Heart Rate'), findsOneWidget);
    expect(find.text('SpO₂'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Blood Pressure'), findsOneWidget);
  });
}
