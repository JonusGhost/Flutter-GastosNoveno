import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:gastosnoveno/Models/Subcategorias.dart';
import 'package:gastosnoveno/Utilerias/Ambiente.dart';
import 'package:gastosnoveno/Pages/home.dart';
import 'package:gastosnoveno/Pages/ListSubcategorias.dart';

class NuevaSubcategoria extends StatefulWidget {
  final Subcategorias? subcategoria;

  const NuevaSubcategoria({this.subcategoria});

  @override
  State<NuevaSubcategoria> createState() => _NuevaSubcategoriaState();
}

class _NuevaSubcategoriaState extends State<NuevaSubcategoria> {
  TextEditingController txtNombreCat = TextEditingController();
  TextEditingController categora_nom = TextEditingController();

  List<Categorias> categorias = [];
  Categorias? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias();

    if (widget.subcategoria != null) {
      txtNombreCat.text = widget.subcategoria!.nombre;

      if (categorias.any((categoria) => categoria.id == widget.subcategoria!.categoria)) {
        categoriaSeleccionada = categorias.firstWhere(
              (categoria) => categoria.id == widget.subcategoria!.categoria,
        );
      }
    }
  }

  void fnObtenerCategorias() async {
    final response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/categorias'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      Iterable mapCategorias = jsonDecode(response.body);
      setState(() {
        categorias = List<Categorias>.from(
          mapCategorias.map((model) => Categorias.fromJson(model)),
        );
      });
    }else {
      print('Error al mostrar categorias');
    }
  }

  Future<void> fnGuardarSubcategoria() async {
    if (categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una Categoria...')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.subcategoria == null ? "Nueva Subcategoría" : "Editar Subcategoría"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(40),
                child: TextFormField(
                  controller: txtNombreCat,
                  decoration:
                  InputDecoration(label: Text('Nombre de la Subcategoría')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: DropdownButton<Categorias>(
                  hint: Text(
                    widget.subcategoria?.nombre_cat == null ? 'Selecciona una Categoria' : '${widget.subcategoria!.nombre_cat}',
                  ),
                  value: categoriaSeleccionada,
                  isExpanded: true,
                  items: categorias.map((Categorias categoria) {
                    return DropdownMenuItem<Categorias>(
                      value: categoria,
                      child: Text(categoria.nombre),
                    );
                  }).toList(),
                  onChanged: (Categorias? newValue) {
                    setState(() {
                      categoriaSeleccionada = newValue;
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                    if (widget.subcategoria == null) {
                      final response = await http.post(
                        Uri.parse(
                            '${Ambiente.urlServer}/api/subcategorias/save'),
                        body: jsonEncode(<String, dynamic>{
                          'nombre': txtNombreCat.text,
                          'id_categoria': categoriaSeleccionada!.id,
                          'categoria': categoriaSeleccionada!.nombre,
                        }),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8'
                        },
                      );
                      print(response.body);
                    } else {
                      final response = await http.put(
                        Uri.parse(
                            '${Ambiente.urlServer}/api/subcategorias/${widget.subcategoria!.id}/update'),
                        body: jsonEncode(<String, dynamic>{
                          'nombre': txtNombreCat.text,
                          'id_categoria': categoriaSeleccionada!.id,
                          'categoria': categoriaSeleccionada!.nombre,
                        }),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8'
                        },
                      );
                      print(response.body);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListSubcategorias()),
                  );
                },
                child: Text(widget.subcategoria == null ? "Guardar" : "Actualizar"),
              ),
            ],
          ),
        )
    );
  }
}