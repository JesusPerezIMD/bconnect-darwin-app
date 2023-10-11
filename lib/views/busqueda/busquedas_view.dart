import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
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
  String? selectedPeriod = 'todos';
  List<DarwinData> reportes = [];
  List<int> uniqueCUCs = [];
  String? selectedCuc;
  
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadReportes('todos');
    cedisList = ['Todos']..addAll(reportes.map((e) => e.cedis ?? '').toSet().toList());
    if (cedisList.isNotEmpty) {
      selectedCedis = cedisList.first; 
    }
  }

  void loadReportes(String dateFilter) async {
    setState(() {
      isLoading = true;
    });

    try {
      reportes = await BConnectService().getReportesByDate(dateFilter);
      uniqueCUCs = reportes.where((e) => e.cuc != null).map((e) => e.cuc!).toSet().toList();
      cedisList = ['Todos']..addAll(reportes.map((e) => e.cedis ?? '').toSet().toList());
        
      if (cedisList.isNotEmpty) {
        selectedCedis = 'Todos';
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime? getLatestUpdate() {
    DateTime? latest;
    for (final report in reportes) {
      final DateTime? current = report.createdOn;
      if (current != null && (latest == null || current.isAfter(latest))) {
        latest = current;
      }
    }
    return latest;
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
            child: Card(
              color: Colors.white,
              elevation: 2, 
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Text(
                      'Actualizado:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      getLatestUpdate() != null ? DateFormat('dd/MM/yyyy').format(getLatestUpdate()!) : 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
            child: Container(
              height: 50.0, 
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    String? urlDescarga = await BConnectService().GetReportesByCreated(
                      selectedCedis ?? 'todos',
                      selectedCuc ?? 'todos',
                      selectedPeriod ?? 'todos'
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
                child: Text(
                  'Descargar Reporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0, 
                  ),
                ),
              ),
            ),
          ),
          NavigationBarComponenet(0), 
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
                        label: "Mostrar",
                        list: periodList,
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            setState(() {
                              selectedPeriod = newValue;
                            });
                            loadReportes(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Material(
                elevation: 0.0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
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
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: uniqueCUCs.length,
                      itemBuilder: (context, index) {
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
                        final String cedis = filteredReports.isNotEmpty ? (filteredReports[0].cedis ?? '') : '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          title: Text('${uniqueCUCs[index]}', style: TextStyle(fontSize: 18)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(clientName, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                              Text(cedis, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DarwinDetailComponent(
                                  darwins: selectedReports,
                                  cedis: selectedCedis ?? 'todos',
                                  cuc: uniqueCUCs[index].toString(),
                                  periodo: selectedPeriod ?? 'todos',
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