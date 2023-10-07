import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../components/components.dart';

Map<String, List<DarwinData>> groupByWeek(List<DarwinData> darwins) {
  Map<String, List<DarwinData>> map = {};
  for (var darwin in darwins) {
    var week = darwin.semana ?? 'Desconocido'; // Proporcionar un valor predeterminado para semanas null
    if (!map.containsKey(week)) {
      map[week] = [];
    }
    map[week]!.add(darwin);
  }
  return map;
}


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
    final groupedDarwins = groupByWeek(darwins);

    return Scaffold(
      appBar: AppBar(
        title: Text('$cuc - ${darwins[0].nomcliente}'),
      ),
      body: ListView(
        children: groupedDarwins.entries.map((entry) {
          final week = entry.key;
          final weekDarwins = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Semana: $week'),
              ...weekDarwins.map((darwin) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomDividerComponent(
                      text: 'Datos del Preventista',
                ), 
                Text('Código Preventa: ${darwin.codPreventa}'),
                Text('Nombre Preventa: ${darwin.nombrePreventa}'),
                Text('Cedis: ${darwin.cedis}'),
                CustomDividerComponent(
                      text: 'Datos del Producto',
                ), 
                Text('Producto: ${darwin.producto}'),
                Text('Código Producto Darwin: ${darwin.codProDarwin}'),
                CustomDividerComponent(
                      text: 'Datos del Dia',
                ), 
                Text('Lunes: ${darwin.lun}'),
                Text('Martes: ${darwin.mar}'),
                Text('Miércoles: ${darwin.mie}'),
                Text('Jueves: ${darwin.jue}'),
                Text('Viernes: ${darwin.vie}'),
                Text('Sábado: ${darwin.sab}'),
                
                Text('Fecha de Creación: ${darwin.createdOn}'), 
                  ],
                );
              }).toList(),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
