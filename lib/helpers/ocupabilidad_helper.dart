import 'package:flutter/material.dart';

class OcupabilidadHelper {
  static void calcularOcupabilidad(
    int i,
    Map<String, TextEditingController> controllers,
    List<List<String>> data,
  ) {
    double resultado = 0.0;
    double resultadom3 = 0.0;

    // Leer valores desde los controladores
    double b6 = double.tryParse(controllers['1_$i']?.text ?? "0") ?? 0.0;
    double b7 = double.tryParse(controllers['2_$i']?.text ?? "0") ?? 0.0;
    double b8 = double.tryParse(controllers['3_$i']?.text ?? "0") ?? 0.0;
    double b9 = double.tryParse(controllers['4_$i']?.text ?? "0") ?? 0.0;

    // Lógica de cálculo según el índice
    double suma = b6 + b7 + b8 - b9;
    if (i == 1) {
      resultado = suma / 1600;
      resultadom3 = suma;
    } else if (i == 2) {
      resultado = suma / 250;
      resultadom3 = suma;
    } else if (i == 3) {
      resultado = suma / 580;
      resultadom3 = suma;
    } else if (i == 4) {
      resultado = suma / 200;
      resultadom3 = suma;
    } else if (i == 5) {
      resultado = suma / 224;
      resultadom3 = suma;
    } else if (i == 6) {
      resultado = suma / 485;
      resultadom3 = suma;
    }

    // Actualizar los resultados en el mapa de datos
    data[6][i] = "${(resultado * 100).toStringAsFixed(2)}%";
    data[5][i] = resultadom3.toStringAsFixed(2);
  }
}
