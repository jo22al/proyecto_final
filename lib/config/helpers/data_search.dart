import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database_helper.dart';
import '../../models/student_model.dart';
import '../../presentation/providers/memory_match_provider.dart';

class DataSearch extends SearchDelegate<String> {
  final DatabaseHelper databaseHelper;

  DataSearch(this.databaseHelper);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: databaseHelper.search(query, 'students'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data;

        return ListView.builder(
          itemCount: results?.length,
          itemBuilder: (context, index) {
            final student = results![index];
            return Consumer(
              builder: (context, ref, child) {
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
                    onPressed: () =>
                        context.push('/edit-student', extra: student),
                    icon: const Icon(Icons.edit),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
