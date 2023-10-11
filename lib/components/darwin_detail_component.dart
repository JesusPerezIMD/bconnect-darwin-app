import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/models.dart';
import '../../components/components.dart';
import '../../services/services.dart';

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
  final String cedis;
  final String cuc;
  final String periodo;
  

  const DarwinDetailComponent({
      Key? key, 
      required this.darwins,
      required this.cedis, 
      required this.cuc,
      required this.periodo,
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
          Expanded( // Añadido Expanded para permitir a la Column ocupar el espacio restante en la fila
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  overflow: TextOverflow.visible, // Cambiado a 'visible' para permitir visualizar el texto overflow
                  softWrap: true, // Asegura que el texto se envuelve y cae a una nueva línea en lugar de desbordar.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreventistaData(List<DarwinData> weekDarwins) {
    return LayoutBuilder(
      builder: (context, constraints) {
        String preventistaData = "${weekDarwins[0].codPreventa?.toString() ?? ''} - ${weekDarwins[0].nombrePreventa?.toString() ?? ''}";
        List<Widget> dataWidgets = [
          _buildRow(const Icon(Icons.person, size: 30), 'Código Preventista y Nombre:', preventistaData),
          _buildRow(const Icon(FontAwesomeIcons.industry, size: 30), 'Cedis:', weekDarwins[0].cedis?.toString() ?? ''),
        ];
        return Column(
          children: [
            CustomDividerComponent(text: 'Colaborador'),
            Column(children: dataWidgets),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final groupedDarwins = groupByWeek(darwins);
    final ScrollController _scrollController = ScrollController();
    final ScrollController _horizontalScrollController = ScrollController();
    final selectedRowNotifier = ValueNotifier<String>('');

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
                bool showLun = weekDarwins.any((darwin) => darwin.lun != 0);
                bool showMar = weekDarwins.any((darwin) => darwin.mar != 0);
                bool showMie = weekDarwins.any((darwin) => darwin.mie != 0);
                bool showJue = weekDarwins.any((darwin) => darwin.jue != 0);
                bool showVie = weekDarwins.any((darwin) => darwin.vie != 0);
                bool showSab = weekDarwins.any((darwin) => darwin.sab != 0);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDividerComponent(text: 'Semana'),
                    _buildRow(const Icon(Icons.calendar_month, size: 30), 'Semana:', week),
                    CustomDividerComponent(text: 'Datos del Producto'),
                    Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalScrollController,
                        child: Container(
                          width: MediaQuery.of(context).size.width, // This ensures that your content takes the whole screen width
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: Center(child: Text('Codigo', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showLun) Expanded( child: Center(child: Text('Lun', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showMar) Expanded( child: Center(child: Text('Mar', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showMie) Expanded( child: Center(child: Text('Mie', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showJue) Expanded( child: Center(child: Text('Jue', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showVie) Expanded( child: Center(child: Text('Vie', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    if (showSab) Expanded( child: Center(child: Text('Sab', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                    Expanded( child: Center(child: Text('Total', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                                  ],
                                ),
                              ),
                    ...weekDarwins.asMap().entries.map((entry) {
                                int idx = entry.key;
                                var darwin = entry.value;
                                Color bgColor = idx.isEven ? Colors.white : (Colors.grey[300] ?? Colors.white); 
                                return ValueListenableBuilder<String>(
                                  valueListenable: selectedRowNotifier,
                                  builder: (context, selectedRow, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        selectedRowNotifier.value = darwin.codProDarwin.toString();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          barrierColor: Colors.transparent,
                                          builder: (BuildContext bc) {
                                            return Container(
                                              height: MediaQuery.of(context).size.height * 0.15,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(FontAwesomeIcons.boxOpen, color: Colors.black, size: 35),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      '${darwin.producto}', 
                                                      style: TextStyle(fontSize: 22, color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ).whenComplete(() => selectedRowNotifier.value = ''); // Resetea el valor después de cerrar el modal
                                      },
                                      child: Container(
                                        color: selectedRow == darwin.codProDarwin.toString() ? Colors.grey : bgColor, // Se usa bgColor aquí
                                        child: Row(
                                          children: [
                                            Expanded( child: Center(child: Text('${darwin.codProDarwin}', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))),),
                                            if (showLun) Expanded( child: Center(child: Text('${darwin.lun}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            if (showMar) Expanded( child: Center(child: Text('${darwin.mar}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            if (showMie) Expanded( child: Center(child: Text('${darwin.mie}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            if (showJue) Expanded( child: Center(child: Text('${darwin.jue}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            if (showVie) Expanded( child: Center(child: Text('${darwin.vie}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            if (showSab) Expanded( child: Center(child: Text('${darwin.sab}', style: TextStyle(fontSize: 18, color: Colors.black)))),
                                            Expanded(  child: Center( child: Text('${(darwin.lun ?? 0) + (darwin.mar ?? 0) + (darwin.mie ?? 0) + (darwin.jue ?? 0) + (darwin.vie ?? 0) + (darwin.sab ?? 0)}',style: TextStyle(fontSize: 18, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
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
                    onPressed: () async {
                      try {
                        String? urlDescarga = await BConnectService().GetReportesByCreated(
                          cedis,
                          cuc,
                          periodo
                        );

                        if (urlDescarga != null) {
                          if (await canLaunch(urlDescarga)) {
                            await launch(urlDescarga);
                          } else {
                            throw 'No se pudo lanzar $urlDescarga';
                          }
                        }                  
                      } catch (e) {
                        print('Error al descargar reportes: $e');
                      }    
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