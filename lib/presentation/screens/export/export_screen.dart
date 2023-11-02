import 'dart:io' as io;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import '../../../data/database_helper.dart';
import '../../../models/student_model.dart';
import '../../widgets/alert/alert.dart';

class ExportScreen extends StatelessWidget {
  static const String routeName = '/export';

  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void exportToExcel() async {
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Agregar datos de ejemplo
      sheet.appendRow(['Nombre', 'Edad']);
      sheet.appendRow(['Juan', 25]);
      sheet.appendRow(['María', 30]);

      var fileBytes = excel.save();

      var path = "/storage/emulated/0/Download/";
      var downloadDir = io.Directory(path);

      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      var filePath = io.File('${downloadDir.path}/output_file_name.xlsx');

      await filePath.writeAsBytes(fileBytes!);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exportado en la ruta de Descargas'),
        ),
      );
    }

    void exportStudentsToExcel(BuildContext context, List<Student> students) {
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Agregar encabezados
      sheet.appendRow([
        'Nombre',
        'Apellido',
        'Fecha de Nacimiento',
        'Mejor Nivel Fácil',
        'Mejor Nivel Medio',
        'Mejor Nivel Difícil',
        'Nombre del Profesor',
        'Apellido del Profesor'
      ]);

      // Agregar datos de los estudiantes
      for (var student in students) {
        sheet.appendRow([
          student.name,
          student.lastname,
          student.dateOfBirth,
          student.bestEasyLevel,
          student.bestMediumLevel,
          student.bestHardLevel,
          student.teacherName,
          student.teacherLastname,
        ]);
      }

      var fileBytes = excel.save();

      var path = "/storage/emulated/0/Download/";
      var downloadDir = io.Directory(path);

      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      var filePath = io.File('${downloadDir.path}/estudiantes.xlsx');
      filePath.writeAsBytesSync(fileBytes!);

      showAlert(context, 'Correcto',
          'Datos de estudiantes exportados en la ruta de Descargas');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar Datos'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List<Student> students =
                await _getAllStudents(1); // Esperar la operación asincrónica
            if (!context.mounted) return;
            exportStudentsToExcel(context, students);
          }, // Agregar el controlador de eventos
          child: const Text('Exportar a Excel'),
        ),
      ),
    );
  }

  Future<List<Student>> _getAllStudents(int id) async {
    List<Student> students = [];

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> studentsData =
        await databaseHelper.getAllStudents();

    students = studentsData.map((data) => Student.fromMap(data)).toList();
    return students;
  }
}
