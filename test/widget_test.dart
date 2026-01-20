import 'package:flutter_test/flutter_test.dart';
import 'package:capturador_datos_offline/main.dart';

void main() {
  testWidgets('Smoke test de la aplicación', (WidgetTester tester) async {
    // Construimos nuestra app sin parámetros obsoletos
    await tester.pumpWidget(const CapturadorApp());

    expect(find.byType(CapturadorApp), findsOneWidget);
  });
}