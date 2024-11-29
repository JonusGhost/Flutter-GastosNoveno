import 'package:flutter_test/flutter_test.dart';
import 'package:gastosnoveno/Models/subcategorias.dart';


void main() {
  group('Pruebas del modelo Subcategorias', () {

    test('Creación de una subcategoría con el constructor', () {
      // Configuración
      final subcategoria = Subcategorias(1, 'Computadoras', 1, 'Tecnología');

      // Verificación
      expect(subcategoria.id, 1);
      expect(subcategoria.nombre, 'Computadoras');
      expect(subcategoria.categoria, 1);
      expect(subcategoria.nombre_cat, 'Tecnología');
    });

    test('Deserialización de JSON a una subcategoría', () {
      // Configuración
      final json = {
        'id': 1,
        'nombre': 'Computadoras',
        'id_categoria': 1,
        'categoria': 'Tecnología'
      };

      // Acción
      final subcategoria = Subcategorias.fromJson(json);

      // Verificación
      expect(subcategoria.id, 1);
      expect(subcategoria.nombre, 'Computadoras');
      expect(subcategoria.categoria, 1);
      expect(subcategoria.nombre_cat, 'Tecnología');
    });

  });

  group('Pruebas del modelo Categoria', () {

    test('Creación de una categoría con el constructor', () {
      // Configuración
      final categoria = Categoria(1, 'Tecnología');

      // Verificación
      expect(categoria.id, 1);
      expect(categoria.nombre, 'Tecnología');
    });

    test('Deserialización de JSON a una categoría', () {
      // Configuración
      final json = {'id': 1, 'nombre': 'Tecnología'};

      // Acción
      final categoria = Categoria.fromJson(json);

      // Verificación
      expect(categoria.id, 1);
      expect(categoria.nombre, 'Tecnología');
    });

  });
}
