import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/database_helper.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  void _cargarTareas() async {
    final tareas = await _databaseHelper.getTareas();
    setState(() {
      _tareas = tareas;
    });
  }

  void _marcarCompletada(Tarea tarea, bool completada) async {
    tarea.completada = completada;
    await _databaseHelper.updateTarea(tarea);
    _cargarTareas();
  }

  void _eliminarTarea(int id) async {
    await _databaseHelper.deleteTarea(id);
    _cargarTareas();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea eliminada')),
    );
  }

  void _mostrarDialogoEliminar(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar esta tarea?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarTarea(id);
                Navigator.of(context).pop();
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Color _obtenerColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador de Tareas - Evaluación 2do'),
        backgroundColor: Colors.blue,
      ),
      body: _tareas.isEmpty
          ? Center(
              child: Text(
                'No hay tareas\n¡Agrega una nueva tarea!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (bool? value) {
                        _marcarCompletada(tarea, value ?? false);
                      },
                    ),
                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tarea.descripcion != null &&
                            tarea.descripcion!.isNotEmpty)
                          Text(tarea.descripcion!),
                        Text('Vence: ${tarea.fechaVencimiento}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _obtenerColorPrioridad(tarea.prioridad),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tarea.prioridad.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskFormScreen(tarea: tarea),
                              ),
                            );
                            _cargarTareas();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _mostrarDialogoEliminar(tarea.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
          _cargarTareas();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}