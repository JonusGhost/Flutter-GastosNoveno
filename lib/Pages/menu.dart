import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/Subcategorias.dart';
import 'home.dart';
import 'ListSubcategorias.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('Categorías'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListSubcategorias()),
              );
              },
              child: Text('Subcategorías'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Menu(),
  ));
}