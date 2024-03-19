import 'package:flutter/material.dart';
import 'package:sqlite/base.dart';
import 'package:sqlite/base_lista.dart';
import 'package:sqlite/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _insert(context), //Llamado a un ALERTDIALOG
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _select,
              child: const Text('select'),
            ),
            /*const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),*/
          ],
        ),
      ),
    );
  }

  // Button onPressed methods
  void _insert(BuildContext context) async {
    final name = TextEditingController();
    final age = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insertar nuevo usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nombre'),
              TextFormField(
                controller: name,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null),
                onChanged: (texto) {},
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Años(int)'),
              TextFormField(
                controller: age,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null),
                onChanged: (texto) {},
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                ///JSON
                Map<String, dynamic> row = {
                  DatabaseHelper.columnName: name.text,
                  DatabaseHelper.columnAge: int.parse(age.text)
                };
                final id = await dbHelper.insert(row);

                debugPrint('inserted row id: $id'); // = print("");

                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _select() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:'); //imprime todos los datos en la consola
    for (final row in allRows) {
      debugPrint(row.toString());
    }

    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => BaseLista(data: allRows)),
  );
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
