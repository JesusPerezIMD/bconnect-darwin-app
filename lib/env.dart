// ignore_for_file: non_constant_identifier_names
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class Environment {
  final GOOGLE_MAP_API_KEY = "AIzaSyDedLDHWHo6oEILIO5ycJYsv6dATa-Aaf8";

  //Local
  // final BCONNECT_API = "http://localhost:17330";
  // final ALIADOS_API = 'https://localhost:44376/api';
  // final UrlApiImages = 'https://localhost:44376/';
  // final TWILIO_API = 'http://localhost:7071/api';
   final GETREPORTESBYCREATED = 'http://localhost:7268/api/Darwin/GetReportesByCreated';
   final GETREPORTESBYDATE = 'http://localhost:7268/api/Darwin/GetReportesByDate';
  // final WHATSAPP_NUMBER = "15165185350";

  //Test
  final BCONNECT_API = "https://bconnectapitest.azurewebsites.net";
  final ALIADOS_API = 'https://bconnect-aliados-api.azurewebsites.net/api';
  final UrlApiImages = 'https://bconnect-aliados-api.azurewebsites.net/';
  final TWILIO_API = 'https://twiliofunctionbconnect.azurewebsites.net/api';
  final WHATSAPP_NUMBER = "15165185350";
  
  //Production
  // final BCONNECT_API = "https://bconnect-auth-api.azurewebsites.net";
  // final ALIADOS_API = 'https://bconnect-aliados-api-prod.azurewebsites.net/api';
  // final UrlApiImages = 'https://bconnect-aliados-api-prod.azurewebsites.net/';
  // final TWILIO_API = 'https://bconnect-twilio-function.azurewebsites.net/api';
  // final WHATSAPP_NUMBER = "5219993991528";
  // final BITACORA_API =
  //    "https://prod-54.westus.logic.azure.com:443/workflows/e0a8aace8890442699d1c5e0cd8c43ec/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=F0eYhXAWdS3wJgEU9IUbPfFYDFjW2twImSvi2-Ovuvg";

  final DEFAULT_LOCATION = const gm.LatLng(20.968147, -89.629872);
  //final SERVICE_ID = "8C3985E3-3B6A-4B0C-B7FD-DD3C4F197D37"; // Darwin
  //final SERVICE_NAME = "SAV Darwin"; // Darwin
  final SERVICE_ID = "z593c9c6-b79f-4bf0-8ba2-fdb0a5345643"; //encuestas
  final SERVICE_NAME = "Encuestas";

  static final Environment _environment = Environment._internal();

  factory Environment() {
    return _environment;
  }

  Environment._internal();
}
