import 'package:flutter/material.dart';
import 'package:sqlite/main.dart';
import 'package:sqlite/base.dart';

class BaseLista extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const BaseLista({Key? key, required this.data}) : super(key: key);

  @override
  State<BaseLista> createState() => _BaseListaState();
}

class _BaseListaState extends State<BaseLista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de datos'),
        // Botón de retroceso en la barra de navegación
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showDialog(context, widget.data[index]['_id'].toString());
            },
            child: Container(
              color: Colors.grey[200], // Color de fondo gris claro
              padding: EdgeInsets.all(
                  8), // Ajuste interno para separar los elementos
              margin: EdgeInsets.symmetric(
                  vertical: 4), // Espacio vertical entre los elementos
              child: ListTile(
                title: Text('name: ${widget.data[index]['name'].toString()}'),
                subtitle: Text('age: ${widget.data[index]['age'].toString()}'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Id del Dato'),
          content: Text('ID: $id'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showUpdateDialog(context, id);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                _delete(int.parse(id));
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  void _update(int id, String nombre, int  edad) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: nombre,
      DatabaseHelper.columnAge: edad
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _showUpdateDialog(BuildContext context, String id) {
  String newName = '';
  String newAge = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modificar datos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                newName = value;
              },
              decoration: InputDecoration(labelText: 'Nuevo nombre'),
            ),
            TextField(
              onChanged: (value) {
                newAge = value;
              },
              decoration: InputDecoration(labelText: 'Nueva edad'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _update(int.parse(id), newName, int.parse(newAge));

              Navigator.of(context).pop(); // Cierra el diálogo de actualización
            },
            child: Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo de actualización
            },
            child: Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
}
