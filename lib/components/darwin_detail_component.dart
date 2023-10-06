import 'package:flutter/material.dart';
import '../../models/models.dart'; // Asegúrate de que la ruta sea correcta

class DarwinDetailComponent extends StatelessWidget {
  final List<DarwinData> darwins;
  final String cuc;

  const DarwinDetailComponent({
      Key? key, 
      required this.darwins, 
      required this.cuc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$cuc - ${darwins[0].nomcliente}'),
      ),
      body: ListView(
        children: darwins.map((darwin) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('Darwin Data ID: ${darwin.darwinDataId}'),
                Text('Punto de Venta: ${darwin.ptovta}'),
                Text('Cedis: ${darwin.cedis}'),
                Text('Marca: ${darwin.marca}'),
                Text('Código Producto Darwin: ${darwin.codProDarwin}'),
                Text('Producto: ${darwin.producto}'),
                Text('Código Preventa: ${darwin.codPreventa}'),
                Text('Nombre Preventa: ${darwin.nombrePreventa}'),
                Text('Lunes: ${darwin.lun}'),
                Text('Martes: ${darwin.mar}'),
                Text('Miércoles: ${darwin.mie}'),
                Text('Jueves: ${darwin.jue}'),
                Text('Viernes: ${darwin.vie}'),
                Text('Sábado: ${darwin.sab}'),
                Text('Semana: ${darwin.semana}'),
                Text('Código Empresa: ${darwin.codemp}'),
                Text('Fecha de Creación: ${darwin.createdOn}'), 
              SizedBox(height: 16), // Añadir espacio entre los conjuntos de datos
            ],
          ),
        )).toList(),
      ),
    );
  }
}
