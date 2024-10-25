import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/LoginResponse.dart';
import 'package:gastosnoveno/Pages/home.dart';
import 'package:gastosnoveno/Pages/menu.dart';
import 'package:gastosnoveno/Utilerias/Ambiente.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                'https://pic.pngsucai.com/00/07/21/714bfdc17ab4016f.webp'),
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtUser,
                decoration: InputDecoration(
                  label: Text('Usuario'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtPass,
                decoration: InputDecoration(
                  label: Text('Contraseña'),
                ),
                obscureText: true,
              ),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                    Uri.parse('${Ambiente.urlServer}/api/login'),
                    body: jsonEncode(<String, dynamic>{
                      'email': txtUser.text,
                      'password': txtPass.text
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8'
                    });

                print(response.body);
                Map<String, dynamic> responseJson = jsonDecode(response.body);
                final loginResponse = LoginResponse.fromJson(responseJson);

                if (loginResponse.acceso == "Ok") {
                  Ambiente.id_usuario = loginResponse.idUsuario;

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Menu()));
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Oops...',
                    text: 'Sos muy malo!',
                  );
                }

                print(response.body);
                return;
              },
              child: Text('Accesar'),
            ),
          ],
        ),
      ),
    );
  }
}
