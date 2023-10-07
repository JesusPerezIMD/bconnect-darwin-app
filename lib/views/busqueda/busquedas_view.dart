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
  
  List<String> cedisList = [];
  String? selectedCedis;
  List<String> periodList = ['todos', 'semana', 'hoy'];
  String? selectedPeriod = 'todos'; // por defecto seleccionado
  List<DarwinData> reportes = [];
  List<int> uniqueCUCs = [];
  
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadReportes(null);
    cedisList = ['Todos']..addAll(reportes.map((e) => e.cedis ?? '').toSet().toList());
    if (cedisList.isNotEmpty) {
      selectedCedis = cedisList.first; 
    }
  }

  void loadReportes(String? dateFilter) async {
    setState(() {
      isLoading = true;
    });

    try {
      if(dateFilter != null) {
        reportes = await BConnectService().getReportesByDate(dateFilter);
      } else {
        reportes = await BConnectService().getReportes();
      }

      uniqueCUCs = reportes.where((e) => e.cuc != null).map((e) => e.cuc!).toSet().toList();
      cedisList = ['Todos']..addAll(reportes.map((e) => e.cedis ?? '').toSet().toList());
        
      if (cedisList.isNotEmpty) {
        selectedCedis = 'Todos'; // Set to 'Todos'
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            setState(() {
                              selectedCedis = newValue;
                            });
                            // Aquí puedes hacer otras operaciones que necesites realizar cuando selectedCedis cambie
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
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            setState(() {
                              selectedPeriod = newValue;
                            });
                            loadReportes(newValue); // Load reportes with selected period
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
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar cliente',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {}); 
                    },
                  ),
                ),
              ),
              Expanded(
                child: isLoading 
                ? Center(child: CircularProgressIndicator()) // mostrando loader
                  : ListView.builder(
                    itemCount: uniqueCUCs.length,
                    itemBuilder: (context, index) {
                      // Aquí se aplica el filtro según el selectedCedis
                      final List<DarwinData> selectedReports = selectedCedis == 'Todos' ? 
                        reportes.where((r) => r.cuc == uniqueCUCs[index]).toList() :
                        reportes.where((r) => r.cuc == uniqueCUCs[index] && r.cedis == selectedCedis).toList();
                        final filteredReports = selectedReports.where((report) {
                        final cuc = report.cuc?.toString() ?? '';
                        final nomcliente = report.nomcliente ?? '';
                        final searchLower = _searchController.text.toLowerCase();
                        return cuc.toLowerCase().contains(searchLower) || nomcliente.toLowerCase().contains(searchLower);
                      }).toList();
                      if (filteredReports.isEmpty) return SizedBox.shrink(); 
                      final String clientName = filteredReports.isNotEmpty ? (filteredReports[0].nomcliente ?? '') : '';
                      return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                      ),
                      title: Text('${uniqueCUCs[index]}'),
                      subtitle: Text(clientName),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DarwinDetailComponent(
                              darwins: selectedReports,
                              cuc: uniqueCUCs[index].toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}