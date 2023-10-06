// ignore_for_file: file_names
import 'dart:convert';
import 'package:bconnect_darwin_app/app_route.dart';
import 'package:bconnect_darwin_app/app_theme.dart';
import 'package:bconnect_darwin_app/env.dart';
import 'package:bconnect_darwin_app/views/account/account_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import '../../models/models.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../services/services.dart';
import 'package:bconnect_darwin_app/components/navigation_bar_component.dart';
import 'package:intl/intl.dart';

class BusquedasPage extends StatefulWidget {
  const BusquedasPage({super.key});

  @override
  State<BusquedasPage> createState() => _BusquedasPageState();
}

class _BusquedasPageState extends State<BusquedasPage> {
  final _formKey = GlobalKey<FormState>();
  BCUser? user;
  BCColaborador? colaborador;
  DarwinData? cuc;

  List<String> cedisList = ['Cedis 1', 'Cedis 2', 'Cedis 3'];
  String? selectedCedis = 'Cedis 1'; // Inicializado con un valor por defecto

  List<String> periodList = ['Periodo 1', 'Periodo 2', 'Periodo 3'];
  String? selectedPeriod = 'Periodo 1'; 

  List<DarwinData> reportes = [];
  List<int> uniqueCUCs = [];

  final TextEditingController _searchController = TextEditingController();

    @override
    void initState() {
      super.initState();
      loadReportes();
    }

    void loadReportes() async {
      try {
        reportes = await BConnectService().getReportes();
        uniqueCUCs = reportes.where((e) => e.cuc != null).map((e) => e.cuc!).toSet().toList();
        
        setState(() {});
      } catch (e) {
        // Handle error as needed
        print("Error loading data: $e");
      }
    }

  @override
  Widget build(BuildContext context) {
    final userInitials =
          '${(user?.names ?? '') == '' ? '' : (user?.names ?? '').substring(0, 1)}${(user?.lastNames ?? '') == '' ? '' : (user?.lastNames ?? '').substring(0, 1)}';
    return Scaffold(
      appBar: BconnectAppBar(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => AccountPage(
                      user ?? BCUser(), colaborador ?? BCColaborador())))
        },
        userInitials: userInitials,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Container(
              height: 50.0, // Altura ajustada del botón
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Inserta la lógica para descargar el reporte
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
                ),
                child: Text(
                  'Descargar Reporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0, // Tamaño de fuente ajustado
                  ),
                ),
              ),
            ),
          ),
          NavigationBarComponenet(0), // Configura tu NavigationBar
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: DropdownButtonExample(
                        value: selectedCedis,
                        label: "Cedis",
                        list: cedisList,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedCedis = value);
                            _BusquedasPageState();
                            setState(() {
                              selectedCedis = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: DropdownButtonExample(
                        value: selectedPeriod,
                        label: "Periodo",
                        list: periodList,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedPeriod = value);
                            _BusquedasPageState();
                            setState(() {
                              selectedPeriod = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            Material(
              elevation: 0.5,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  dense: false,
                  visualDensity: VisualDensity(vertical: -3.4),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: -20),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  horizontalTitleGap: 0,
                  title: _searchController.text.isEmpty
                      ? Text('Buscar cliente',
                          style: TextStyle(fontSize: 16, color: Colors.grey))
                      : Text(_searchController.text,
                          style: TextStyle(fontSize: 16)),
                  onTap: () {
                    // Implement your search logic here
                  },
                ),
              ),
            ),
              Expanded(
                child: ListView.builder(
                  itemCount: uniqueCUCs.length,
                  itemBuilder: (context, index) {
                    final List<DarwinData> selectedReports = reportes.where((r) => r.cuc == uniqueCUCs[index]).toList();
                    final String clientName = selectedReports.isNotEmpty ? (selectedReports[0].nomcliente ?? '') : '';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                      ),
                      title: Text('${uniqueCUCs[index]}'), // Muestra el CUC único
                      subtitle: Text(clientName), // Muestra el nombre del cliente correspondiente
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DarwinDetailComponent(
                              darwins: selectedReports,
                              cuc: uniqueCUCs[index].toString(), // Convertimos el CUC a String para el título
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}