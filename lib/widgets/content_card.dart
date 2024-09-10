import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.context,
    required this.screenToNavigate,
  });

  final String title;
  final IconData icon;
  final BuildContext context;
  final Widget screenToNavigate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          // Navegar a la siguiente vista cuando se hace clic en la tarjeta
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenToNavigate),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0), // Puntas redondeadas
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Puntas redondeadas
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.00),
                          color: const Color.fromRGBO(39, 63, 114, 1),
                        ),
                        child: Icon(
                          icon,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(39, 63, 114, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4.0,
                  width: double.infinity,
                  color: const Color.fromRGBO(39, 63, 114, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
