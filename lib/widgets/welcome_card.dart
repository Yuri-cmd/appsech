import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                height: 4.0,
                width: double.infinity,
                color: const Color.fromRGBO(37, 211, 102, 1),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  color: Colors.white,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido Yuri Marroquin!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gracias por ingresar a nuestro portal virtual, de esta forma juntos cuidamos a nuestro planeta.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
