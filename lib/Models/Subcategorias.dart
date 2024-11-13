class Subcategorias {
  final int id;
  final String nombre;
  final int categoria;
  final String nombre_cat;

  Subcategorias(this.id, this.nombre, this.categoria, this.nombre_cat);

  Subcategorias.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        categoria = json['id_categoria'],
        nombre_cat = json['categoria'];
}

class Categoria {
  final int id;
  final String nombre;

  Categoria(this.id, this.nombre);

  Categoria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre  = json['nombre'];
}