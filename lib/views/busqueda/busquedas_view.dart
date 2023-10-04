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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuestas Page'),
      ),
      body: Center(
        child: Text('Esta es la página de Encuestas'),
      ),
    );
  }
}