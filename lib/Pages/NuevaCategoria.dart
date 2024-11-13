//stful para poner todo automaticamente
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gastosnoveno/Utilerias/Ambiente.dart';
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:gastosnoveno/Pages/home.dart';

class NuevaCategoria extends StatefulWidget {
  final Categorias? categoria; //Recibir la categoria para editar

  const NuevaCategoria({super.key, this.categoria});

  @override
  State<NuevaCategoria> createState() => _NuevaCategoriaState();
}

class _NuevaCategoriaState extends State<NuevaCategoria> {
  TextEditingController txtNombreCat = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      // Si es para editar, llenar el campo con el valor actual
      txtNombreCat.text = widget.categoria!.nombre;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.categoria == null ? "Nueva Categoría" : "Editar Categoría"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtNombreCat,
                decoration:
                InputDecoration(label: Text('Nombre de la Categoría')),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (widget.categoria == null) {
                  final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/categorias/save'),
                      body: jsonEncode(<String, dynamic>{
                        'nombre': txtNombreCat.text,
                        'id_usuario': Ambiente.id_usuario
                      }),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                  );
                  print(response.body);
                } else {
                  // Actualizar categoría existente
                  final response = await http.put(
                    Uri.parse(
                        '${Ambiente.urlServer}/api/categorias/${widget.categoria!.id}/update'),
                    body: jsonEncode(<String, dynamic>{
                      'nombre': txtNombreCat.text,
                      'id_usuario': Ambiente.id_usuario
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8'
                    },
                  );
                  print(response.body);
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: Text(widget.categoria == null ? "Guardar" : "Actualizar"),
            ),
          ],
        ),
      )
    );
  }
}
