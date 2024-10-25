import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:http/http.dart' as http;
import 'package:gastosnoveno/Pages/NuevaCategoria.dart';
import 'package:gastosnoveno/Utilerias/Ambiente.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Categorias> categorias = [];

  void fnObtenerCategorias() async {
    final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/categorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });

    print(response.body);

    Iterable mapCategorias = jsonDecode(response.body);
    categorias = List<Categorias>.from(
        mapCategorias.map((model) => Categorias.fromJson(model)));
    categorias.sort((a,b) => a.id.compareTo(b.id));

    setState(() {});
  }

  void fnEliminarCategoria(int id) async {
    final response = await http.delete(
      Uri.parse('${Ambiente.urlServer}/api/categorias/$id/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Remueve la categoría de la lista localmente
      categorias.removeWhere((categoria) => categoria.id == id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría eliminada éxitosamente')),
      );
    } else {
      print('Error al eliminar: ${response.body}'); // Imprimir el error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría')),
      );
    }
  }

  Widget _ListViewCategorias() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categorias[index].nombre),
          subtitle: Text('Num: ${categorias[index].id}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NuevaCategoria(categoria: categorias[index]),
                    ),
                  );
                },
              ),
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _conEliminacion(categorias[index].id);
                  },
              ),
            ],
          ),
        );
      },
    );
  }

  void _conEliminacion(int id){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                fnEliminarCategoria(id); // Llamar a la función de eliminación
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
    fnObtenerCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: _ListViewCategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NuevaCategoria()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
