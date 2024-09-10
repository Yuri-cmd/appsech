import 'package:flutter/material.dart';

class NavOption {
  final String title;
  final IconData icon;
  final Widget targetView;

  NavOption({
    required this.title,
    required this.icon,
    required this.targetView,
  });
}

class NavOptionsView extends StatelessWidget {
  final List<NavOption> options;

  const NavOptionsView({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(39, 63, 114, 1),
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...options.map((option) {
            return ListTile(
              leading: Icon(option.icon),
              title: Text(option.title),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => option.targetView),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
