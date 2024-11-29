import 'package:flutter_test/flutter_test.dart';

// Función a probar
int sum(int a, int b) {
  return a + b;
}

void main() {
  group('Pruebas de suma', () {
    test('Suma de dos números positivos', () {
      // Configuración
      int result = sum(2, 3);

      // Verificación
      expect(result, 5);
    });

    test('Suma de un número positivo y cero', () {
      int result = sum(5, 0);

      expect(result, 5);
    });

    test('Suma de dos números negativos', () {
      int result = sum(-2, -3);

      expect(result, -5);
    });
  });
}
