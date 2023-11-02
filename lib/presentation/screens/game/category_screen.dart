import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data.dart';
import '../../../models/student_model.dart';
import '../../providers/memory_match_provider.dart';

class CategoryScreen extends ConsumerWidget {
  static const String routeName = '/category_screen';

  final Student student;

  const CategoryScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 100,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    context.push('/student_info_screen', extra: student);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 50,
                            ),
                            Text(
                              '${student.name} ${student.lastname}',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  CategoryCard(
                      title: 'Animales',
                      imageUrl: 'assets/categories/animals_category.png',
                      onTap: () {
                        ref
                            .read(gameProvider.notifier)
                            .sourceArrayList(fillSourceArray());
                        context.push(
                          '/user_game_levels',
                          extra: student,
                        );
                      }),
                  CategoryCard(
                      title: 'Figuras',
                      imageUrl: 'assets/categories/geomet.png',
                      onTap: () => {
                            ref
                                .read(gameProvider.notifier)
                                .sourceArrayList(formasSourceArray()),
                            context.push('/user_game_levels', extra: student)
                          }),
                  CategoryCard(
                      title: 'Hogar',
                      imageUrl: 'assets/categories/house.png',
                      onTap: () => {
                            ref
                                .read(gameProvider.notifier)
                                .sourceArrayList(homecategory()),
                            context.push('/user_game_levels', extra: student)
                          }),
                  CategoryCard(
                      title: 'Profesiones',
                      imageUrl: 'assets/categories/professionals.png',
                      onTap: () => {
                            ref
                                .read(gameProvider.notifier)
                                .sourceArrayList(profesionscategory()),
                            context.push('/user_game_levels', extra: student)
                          }),
                  CategoryCard(
                      title: 'Juguetes',
                      imageUrl: 'assets/categories/juguetes.png',
                      onTap: () => {
                            ref
                                .read(gameProvider.notifier)
                                .sourceArrayList(toyscategory()),
                            context.push('/user_game_levels', extra: student)
                          }),
                  CategoryCard(
                      title: 'Transportes',
                      imageUrl: 'assets/categories/transporte.png',
                      onTap: () => {
                            ref
                                .read(gameProvider.notifier)
                                .sourceArrayList(transportscategory()),
                            context.push('/user_game_levels', extra: student)
                          })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(imageUrl),
              fit: BoxFit.contain,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoStudent extends ConsumerWidget {
  final String name;
  final String lastName;

  const InfoStudent(this.name, this.lastName, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nombre: $name $lastName'),
        Text(
            'Mejor tiempo en nivel fácil: ${ref.watch(gameProvider).bestEasyLevel}'),
        Text(
            'Mejor tiempo en nivel medio: ${ref.watch(gameProvider).bestMediumLevel}'),
        Text(
            'Mejor tiempo en nivel difícil: ${ref.watch(gameProvider).bestHardLevel}'),
      ],
    );
  }
}
