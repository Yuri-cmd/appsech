class DataModel {
  final int id;
  final DateTime fecha;
  final String horaIngreso;
  final String horaSalida;
  final String noPedidoDeVenta;
  final String noBoleta;
  final String codigoResiduo;
  final String residuo;
  final String nombreProductoCliente;
  final String clasificacionSigersol;
  final String cliente;
  final String gestor;
  final String transportista;
  final String generador;
  final String guiaRemitente;
  final String guiaTransportista;
  final String cantidad;
  final String unidadVenta;
  final String valorUnitario;
  final String valorTotal;
  final String manifiesto;
  final String placa;
  final String zonaDeRecepcion;
  final String nombreTratamiento;
  final String zonaTratamiento;
  final String ph;
  final String inflamabilidad;
  final String coordenadas;
  final String cantidadContenedor;
  final String tipoContenedor;
  final String contenedoresAdicionales;
  final String centroDeResponsabilidad;
  final String ccostoCode;
  final String ccCesionInternaCode;
  final String pesaje;
  final String createdAt;
  final String updatedAt;

  DataModel({
    required this.id,
    required this.fecha,
    required this.horaIngreso,
    required this.horaSalida,
    required this.noPedidoDeVenta,
    required this.noBoleta,
    required this.codigoResiduo,
    required this.residuo,
    required this.nombreProductoCliente,
    required this.clasificacionSigersol,
    required this.cliente,
    required this.gestor,
    required this.transportista,
    required this.generador,
    required this.guiaRemitente,
    required this.guiaTransportista,
    required this.cantidad,
    required this.unidadVenta,
    required this.valorUnitario,
    required this.valorTotal,
    required this.manifiesto,
    required this.placa,
    required this.zonaDeRecepcion,
    required this.nombreTratamiento,
    required this.zonaTratamiento,
    required this.ph,
    required this.inflamabilidad,
    required this.coordenadas,
    required this.cantidadContenedor,
    required this.tipoContenedor,
    required this.contenedoresAdicionales,
    required this.centroDeResponsabilidad,
    required this.ccostoCode,
    required this.ccCesionInternaCode,
    required this.pesaje,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      horaIngreso: json['hora_ingreso'] ?? '',
      horaSalida: json['hora_salida'] ?? '',
      noPedidoDeVenta: json['no_pedido_de_venta'] ?? '',
      noBoleta: json['no_boleta'] ?? '',
      codigoResiduo: json['codigo_residuo'] ?? '',
      residuo: json['residuo'] ?? '',
      nombreProductoCliente: json['nombre_producto_cliente'] ?? '',
      clasificacionSigersol: json['clasificacion_sigersol'] ?? '',
      cliente: json['cliente'] ?? '',
      gestor: json['gestor'] ?? '',
      transportista: json['transportista'] ?? '',
      generador: json['generador'] ?? '',
      guiaRemitente: json['guia_remitente'] ?? '',
      guiaTransportista: json['guia_transportista'] ?? '',
      cantidad: json['cantidad'] ?? '',
      unidadVenta: json['unidad_venta'] ?? '',
      valorUnitario: json['valor_unitario'] ?? '',
      valorTotal: json['valor_total'] ?? '',
      manifiesto: json['manifiesto'] ?? '',
      placa: json['placa'] ?? '',
      zonaDeRecepcion: json['zona_de_recepcion'] ?? '',
      nombreTratamiento: json['nombre_tratamiento'] ?? '',
      zonaTratamiento: json['zona_tratamiento'] ?? '',
      ph: json['ph'] ?? '',
      inflamabilidad: json['inflamabilidad'] ?? '',
      coordenadas: json['coordenadas'] ?? '',
      cantidadContenedor: json['cantidad_contenedor'] ?? '',
      tipoContenedor: json['tipo_contenedor'] ?? '',
      contenedoresAdicionales: json['contenedores_adicionales'] ?? '',
      centroDeResponsabilidad: json['centro_de_responsabilidad'] ?? '',
      ccostoCode: json['ccosto_code'] ?? '',
      ccCesionInternaCode: json['cc_cesion_interna_code'] ?? '',
      pesaje: json['pesaje'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
