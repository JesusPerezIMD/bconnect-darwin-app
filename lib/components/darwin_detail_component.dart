import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../components/components.dart';

Map<String, List<DarwinData>> groupByWeek(List<DarwinData> darwins) {
  Map<String, List<DarwinData>> map = {};
  for (var darwin in darwins) {
    var week = darwin.semana ?? 'Desconocido';
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

  Widget _buildRow(Icon icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon, // Display the icon
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

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
              CustomDividerComponent(text: 'Datos del Preventista'),
              _buildRow(const Icon(Icons.info, size: 20), 'Código Preventista:', weekDarwins[0].codPreventa?.toString() ?? ''),
              _buildRow(const Icon(Icons.info, size: 20), 'Nombre Preventista:', weekDarwins[0].nombrePreventa?.toString() ?? ''),
              _buildRow(const Icon(Icons.info, size: 20), 'Cedis:', weekDarwins[0].cedis?.toString() ?? ''),
              CustomDividerComponent(text: 'Datos del Producto'),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Expanded(child: Text('Producto')),
                    Expanded(child: Text('Codigo')),
                    Expanded(child: Text('Lun')),
                    Expanded(child: Text('Mar')),
                    // ... More headers for other days
                  ],
                ),
              ),
              ...weekDarwins.map((darwin) => 
                Row(
                  children: [
                    Expanded(
                      child: Text('${darwin.producto}'),
                    ),
                    Expanded(
                      child: Text('${darwin.codProDarwin}'),
                    ),
                    Expanded(
                      child: Text('${darwin.lun}'),
                    ),
                    Expanded(
                      child: Text('${darwin.mar}'),
                    ),
                    //... More days
                  ],
                )
              ).toList(),       
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}