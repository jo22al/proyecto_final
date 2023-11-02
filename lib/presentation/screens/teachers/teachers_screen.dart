import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_project/data/database_helper.dart';
import 'package:memory_project/models/teacher_model.dart';

class TeachersScreen extends StatefulWidget {
  static const routeName = '/teachers';

  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  List<Teacher> teachers = [];

  @override
  void initState() {
    super.initState();
    _getAllTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final isInForeground = ModalRoute.of(context)?.isCurrent ?? false;

    if (isInForeground) {
      _getAllTeachers();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores'),
      ),
      body: ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(teacher.name[0]),
              ),
              title: Text(teacher.name),
              subtitle: Text(teacher.lastname),
              onTap: () {},
              trailing: IconButton(
                onPressed: () => context.push('/edit-teacher', extra: teacher),
                icon: const Icon(Icons.edit),
              ),
            );
          }),
    );
  }

  void _getAllTeachers() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> teachersMapList =
        await databaseHelper.getAllActiveTeachers('teachers');
    setState(() {
      teachers = teachersMapList
          .map((teacherMap) => Teacher.fromMap(teacherMap))
          .toList();
    });
  }
}
