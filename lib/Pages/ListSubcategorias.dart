import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gastosnoveno/Utilerias/Ambiente.dart';
import 'package:gastosnoveno/Models/Subcategorias.dart';
import 'package:gastosnoveno/Pages/NuevaSubcategoria.dart';

class ListSubcategorias extends StatefulWidget {
  const ListSubcategorias({super.key});

  @override
  State<ListSubcategorias> createState() => _ListSubcategoriasState();
}

class _ListSubcategoriasState extends State<ListSubcategorias> {
  List<Subcategorias> subcategorias = [];
  bool isLoading = true;
  String? errorMessage;

  void fnObtenerSubcategorias() async {
    try {
      final response = await http.get(
          Uri.parse('${Ambiente.urlServer}/api/subcategorias'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Iterable mapSubcategorias = jsonDecode(response.body);
        subcategorias = List<Subcategorias>.from(
          mapSubcategorias.map((model) => Subcategorias.fromJson(model)),
        );
        //subcategorias.sort((a, b) => a.id.compareTo(b.id));
      } else {
        // Maneja un error de respuesta que no sea 200
        errorMessage =
            'Error al obtener las subcategorías: ${response.statusCode}';
      }
    } catch (e) {
      // Manejo de errores de red u otros
      errorMessage = 'Error al obtener las subcategorías: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fnEliminarSubcategoria(int id) async {
    final response = await http.delete(
      Uri.parse('${Ambiente.urlServer}/api/subcategorias/$id/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      subcategorias.removeWhere((subcategoria) => subcategoria.id == id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subcategoría eliminada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la subcategoría')),
      );
    }
  }

  Widget _ListviewSubcategorias() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return ListView.builder(
      itemCount: subcategorias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(subcategorias[index].nombre),
          subtitle: Text(
              'Categoría: ${subcategorias[index].nombre_cat}'), // Aquí muestras el nombre de la categoría
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NuevaSubcategoria(subcategoria: subcategorias[index]),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmarEliminacion(subcategorias[index].id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content:
              Text('¿Estás seguro de que deseas eliminar esta subcategoría?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                fnEliminarSubcategoria(id);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnObtenerSubcategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategorías"),
      ),
      body: _ListviewSubcategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevaSubcategoria()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
