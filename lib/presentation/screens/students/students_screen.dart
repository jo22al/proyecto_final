import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/helpers/data_search.dart';
import '../../../data/database_helper.dart';
import '../../../models/student_model.dart';
import '../../providers/memory_match_provider.dart';
import '../../widgets/menu/side_menu.dart';

class StudentsScreen extends StatefulWidget {
  static const String routeName = '/students';

  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String? name;
  String? lastName;
  String? idTeacher;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      idTeacher = prefs.getString('id') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('id') == null) {
        context.pushReplacement('/');
      }
    });

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Bienvenido $name $lastName'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
                context: context, delegate: DataSearch(databaseHelper)),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('name');
              prefs.remove('lastName');
              prefs.remove('id');
              if (!context.mounted) return;
              context.pushReplacement('/');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StudentsList(idTeacher: idTeacher ?? '0'),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-student'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StudentsList extends ConsumerStatefulWidget {
  final String idTeacher;

  const StudentsList({super.key, required this.idTeacher});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentsListState();
}

class _StudentsListState extends ConsumerState<StudentsList> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _getAllStudents(int.parse(widget.idTeacher));
  }

  @override
  Widget build(BuildContext context) {
    final isInForeground = ModalRoute.of(context)?.isCurrent ?? false;

    if (isInForeground) {
      _getAllStudents(int.parse(widget.idTeacher));
    }

    if (students.isNotEmpty) {
      return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(student.name[0]),
            ),
            title: Text(student.name),
            subtitle: Text(student.lastname),
            onTap: () {
              ref
                  .read(gameProvider.notifier)
                  .bestEasyLevel(student.bestEasyLevel);

              ref.read(gameProvider.notifier).bestMediumLevel(
                    student.bestMediumLevel,
                  );

              ref.read(gameProvider.notifier).bestHardLevel(
                    student.bestHardLevel,
                  );
              context.push('/category_screen', extra: student);
            },
            trailing: IconButton(
              onPressed: () => context.push('/edit-student', extra: student),
              icon: const Icon(Icons.edit),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _getAllStudents(int id) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> studentsData =
        await databaseHelper.getRowById('students', id);

    if (mounted) {
      setState(() {
        students = studentsData.map((data) => Student.fromMap(data)).toList();
      });
    }
  }
}
