import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TaskFormScreen extends StatefulWidget {
  final Tarea? tarea;

  TaskFormScreen({this.tarea});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _prioridad = 'media';
  DateTime _fechaVencimiento = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.tarea != null) {
      _tituloController.text = widget.tarea!.titulo;
      _descripcionController.text = widget.tarea!.descripcion ?? '';
      _prioridad = widget.tarea!.prioridad;
      _fechaVencimiento = DateTime.parse(widget.tarea!.fechaVencimiento);
    }
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaVencimiento) {
      setState(() {
        _fechaVencimiento = picked;
      });
    }
  }

  void _guardarTarea() {
    if (_formKey.currentState!.validate()) {
      final tarea = Tarea(
        id: widget.tarea?.id,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text.isEmpty
            ? null
            : _descripcionController.text,
        prioridad: _prioridad,
        fechaVencimiento: _fechaVencimiento.toIso8601String().split('T')[0],
        completada: widget.tarea?.completada ?? false,
      );

      Navigator.pop(context, tarea);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarea == null
            ? 'Nueva Tarea'
            : 'Editar Tarea'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridad,
                decoration: InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
                items: ['alta', 'media', 'baja']
                    .map((prioridad) => DropdownMenuItem(
                          value: prioridad,
                          child: Text(
                            prioridad.toUpperCase(),
                            style: TextStyle(
                              color: prioridad == 'alta'
                                  ? Colors.red
                                  : prioridad == 'media'
                                      ? Colors.orange
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _prioridad = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: _seleccionarFecha,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha de vencimiento',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_fechaVencimiento.toIso8601String().split('T')[0]),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarTarea,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  widget.tarea == null ? 'CREAR TAREA' : 'ACTUALIZAR TAREA',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}