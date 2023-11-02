import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });
          if (value == 0) {
            context.push('/teachers');
          } else if (value == 1) {
            context.push('/export');
          }
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        children: const [
          NavigationDrawerDestination(
            icon: Icon(Icons.person_2_outlined),
            label: Text('Profesores'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.download),
            label: Text('Exportar Datos'),
          ),
        ]);
  }
}
