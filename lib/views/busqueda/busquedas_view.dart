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

  List<String> cedisList = ['Cedis 1', 'Cedis 2', 'Cedis 3'];
  String? selectedCedis;

  List<String> periodList = ['Periodo 1', 'Periodo 2', 'Periodo 3'];
  String? selectedPeriod;

  final TextEditingController _searchController = TextEditingController();

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
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50.0, // Altura ajustada del botón
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Inserta la lógica para descargar el reporte
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
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
                    child: DropdownButtonFormField(
                      value: selectedCedis,
                      decoration: InputDecoration(labelText: 'Cedis'),
                      items: cedisList.map((cedis) {
                        return DropdownMenuItem(
                          value: cedis,
                          child: Text(cedis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCedis = value as String?;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedPeriod,
                      decoration: InputDecoration(labelText: 'Periodo'),
                      items: periodList.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value as String?;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar clientes',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                // Implementa la lógica de búsqueda
              ),
              // ... Añade más widgets si los necesitas
            ],
          ),
        ),
      ),
    );
  }
}