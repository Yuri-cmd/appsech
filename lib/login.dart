import 'package:flutter/material.dart';
import 'package:appsech/home.dart';
import 'package:appsech/helpers/helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Evita que la vista se ajuste cuando aparece el teclado
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ClipPath(
              clipper: CustomShape(),
              child: Container(
                color: const Color.fromRGBO(39, 63, 114, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/logo.png', // Ruta de la imagen en tu proyecto
                      height: 80, // Altura de la imagen
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.email),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Acción para recuperar contraseña
                      },
                      child: const Text('¿OLVIDASTE TU CONTRASEÑA?'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Aquí puedes agregar la lógica de autenticación
                      // En este ejemplo, simplemente comparamos valores estáticos
                      if (_usernameController.text == 'prueba' &&
                          _passwordController.text == '123') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error de inicio de sesión'),
                            content: const Text(
                                'Credenciales incorrectas. Por favor, inténtalo de nuevo.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(39, 63, 114, 1),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Ingresar'),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
