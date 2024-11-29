import 'package:flutter_test/flutter_test.dart';
import 'package:gastosnoveno/Models/categorias.dart'; // Asegúrate de importar la clase Categorias

void main() {
  group('Pruebas del modelo Categorias', () {

    test('Creación de una categoría con el constructor', () {
      // Configuración
      final categoria = Categorias(1, 'Tecnología');

      // Verificación
      expect(categoria.id, 1);
      expect(categoria.nombre, 'Tecnología');
    });

    test('Deserialización de JSON a una categoría', () {
      // Configuración
      final json = {'id': 1, 'nombre': 'Tecnología'};

      // Acción
      final categoria = Categorias.fromJson(json);

      // Verificación
      expect(categoria.id, 1);
      expect(categoria.nombre, 'Tecnología');
    });

  });
}
