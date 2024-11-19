import 'package:appsech/df.dart';
import 'package:appsech/grifo.dart';
import 'package:appsech/ptari.dart';
import 'package:appsech/tratamiento.dart';
import 'package:flutter/material.dart';

import 'package:appsech/almacen.dart';
import 'package:appsech/horometro.dart';
import 'package:appsech/recepcion.dart';
import 'package:appsech/ingreso_planta.dart';
import 'package:appsech/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(39, 63, 114, 1),
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 40), // Añade tu logo aquí
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const NavOptions(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WelcomeCard(),
            ContentCard(
                title: 'Ingresos a Planta',
                icon: Icons.local_shipping,
                context: context,
                screenToNavigate: const IngresoPlanta()),
            ContentCard(
                title: 'Maquinaria - HR',
                icon: Icons.local_shipping,
                context: context,
                screenToNavigate: const Horometro()),
            // ContentCard(
            //     title: 'Grafica',
            //     icon: Icons.swap_horiz,
            //     context: context,
            //     screenToNavigate: BarChartSample()),
            ContentCard(
                title: 'Recepción unidades',
                icon: Icons.home,
                context: context,
                screenToNavigate: const Recepcion()),
            ContentCard(
                title: 'Almacen Temporal',
                icon: Icons.assignment,
                context: context,
                screenToNavigate: const Almacen()),
            ContentCard(
                title: 'Tratamiento',
                icon: Icons.local_shipping_outlined,
                context: context,
                screenToNavigate: const Tratamiento()),
            ContentCard(
                title: 'DF',
                icon: Icons.local_drink,
                context: context,
                screenToNavigate: const DfPage()),
            // ContentCard(
            //     title: 'Maquinaria',
            //     icon: Icons.local_drink,
            //     context: context,
            //     screenToNavigate: BarChartSample()),
            ContentCard(
                title: 'Grifo',
                icon: Icons.local_drink,
                context: context,
                screenToNavigate: const Grifo()),
            ContentCard(
                title: 'Ptari',
                icon: Icons.local_drink,
                context: context,
                screenToNavigate: Ptari()),
          ],
        ),
      ),
    );
  }
}
