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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Center(
            child: icon,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildPreventistaData(List<DarwinData> weekDarwins) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 725;
        List<Widget> dataWidgets = [
          _buildRow(const Icon(Icons.info, size: 20), 'Código Preventista:', weekDarwins[0].codPreventa?.toString() ?? ''),
          _buildRow(const Icon(Icons.info, size: 20), 'Nombre Preventista:', weekDarwins[0].nombrePreventa?.toString() ?? ''),
          _buildRow(const Icon(Icons.info, size: 20), 'Cedis:', weekDarwins[0].cedis?.toString() ?? ''),
        ];
        return Column(
          children: [
            CustomDividerComponent(text: 'Datos del Preventista'),
            isWide ? Row(children: dataWidgets.map((widget) => Expanded(child: widget)).toList()) : Column(children: dataWidgets),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedDarwins = groupByWeek(darwins);
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('$cuc - ${darwins[0].nomcliente}'),
      ),
      body: Column(
        children: [
          if (darwins.isNotEmpty) _buildPreventistaData(darwins),
          Expanded(
            child: ListView(
              children: groupedDarwins.entries.map((entry) {
                final week = entry.key;
                final weekDarwins = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDividerComponent(text: 'Fecha'),
                    _buildRow(const Icon(Icons.calendar_month, size: 20), 'Semana:', week),
                    CustomDividerComponent(text: 'Datos del Producto'),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 725;
                      return Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: isWide ? constraints.maxWidth : 0,
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      children: [
                                        isWide ? Expanded(child: Center(child: Text('Producto', style: TextStyle(fontSize: 12, color: Colors.grey))))
                                              : Container(width: 300, child: Center(child: Text('Producto', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Codigo', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 100, child: Center(child: Text('Codigo', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Lun', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Lun', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Mar', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Mar', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Mie', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Mie', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Jue', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Jue', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Vie', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Vie', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                        isWide ? Expanded(child: Center(child: Text('Sab', style: TextStyle(fontSize: 12, color: Colors.grey)))) 
                                              : Container(width: 50, child: Center(child: Text('Sab', style: TextStyle(fontSize: 12, color: Colors.grey)))),
                                      ],
                                    ),
                                  ),
                                  ...weekDarwins.map((darwin) =>
                                    Row(
                                      children: [
                                        isWide  ? Expanded(
                                            child: Row(
                                              children: [
                                                Icon(Icons.label, color: Colors.black, size: 20),
                                                SizedBox(width: 4),
                                                Text('${darwin.producto}', style: TextStyle(fontSize: 14, color: Colors.black)),
                                              ],
                                            ),
                                          )
                                          : Container(
                                            width: 300, 
                                            child: Row(
                                              children: [
                                                Icon(Icons.label, color: Colors.black, size: 20),
                                                SizedBox(width: 4),
                                                Text('${darwin.producto}', style: TextStyle(fontSize: 14, color: Colors.black)),
                                              ],
                                            ),
                                          ),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.codProDarwin}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 100, child: Center(child: Text('${darwin.codProDarwin}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.lun}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.lun}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.mar}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.mar}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.mie}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.mie}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.jue}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.jue}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.vie}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.vie}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                        isWide ? Expanded(child: Center(child: Text('${darwin.sab}', style: TextStyle(fontSize: 14, color: Colors.black)))) 
                                              : Container(width: 50, child: Center(child: Text('${darwin.sab}', style: TextStyle(fontSize: 14, color: Colors.black)))),
                                      ],
                                    )
                                  ).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),  
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text('Descargar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}