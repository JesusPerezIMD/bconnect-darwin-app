import 'dart:convert';
import 'package:bconnect_darwin_app/env.dart';
import 'package:bconnect_darwin_app/models/models.dart';
import 'package:http/http.dart' as http;


class BConnectService {
  String? token;
  String apiUrl = Environment().BCONNECT_API;
  String apiReportesByCreated = Environment().GETREPORTESBYCREATED;
  String apiReportesByDate = Environment().GETREPORTESBYDATE;

  BConnectService();

  Future<AuthUser?> authByAccessToken(String token, String serviceId) async {
    try {
      AuthUser? user;
      final response = await http.post(
          Uri.parse('$apiUrl/Auth/AuthByAccessToken'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, String>{
            'access_token': token,
            'servicesId': serviceId
          }));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        user = AuthUser.fromJson(result);
      }
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AuthUserCode?> authByAccessCode(String code, String serviceId) async {
    try {
      AuthUserCode? userCode;
      final response = await http.post(Uri.parse('$apiUrl/Auth/AccessCode'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(
              <String, String>{'accessCode': code, 'servicesId': serviceId}));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        userCode = AuthUserCode.fromJson(result);
      }
      return userCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BCColaborador?> getColaborador(String userId) async {
    try {
      BCColaborador? colaborador;
      final response = await http.get(
        Uri.parse('$apiUrl/Hub/Profiles/ColaboradorByUserId?userId=$userId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        colaborador = BCColaborador.fromJson(result);
      }
      return colaborador;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BCUser?> chechAccessToken(String token) async {
    try {
      BCUser? user;
      final response =
          await http.get(Uri.parse('$apiUrl/Auth/CheckAccessToken'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        user = BCUser.fromJson(result);
      }
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<FirebaseUser?> firebaseAuth(String token) async {
    try {
      FirebaseUser? firebaseUser;
      final response =
          await http.get(Uri.parse('$apiUrl/Auth/AuthUser'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        firebaseUser = FirebaseUser.fromJson(result);
      }
      return firebaseUser;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> GetReportesByCreated(String cedis, String cuc, String date) async {
    try {
      final response = await http.get(
        Uri.parse("$apiReportesByCreated/$cedis/$cuc/$date"),
        headers: {},
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return DarwinData.fromJson(result).urlDescarga;
      } else {
        throw Exception('Failed to load reportes by date, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading reportes by date: $e');
      throw e;
    }
  }

  Future<List<DarwinData>> getReportesByDate(String date) async {
    try {
      List<DarwinData> reportes = [];
      final response = await http.get(
        Uri.parse("$apiReportesByDate/$date"),
        headers: {
        }
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        for (var data in result) {
          reportes.add(DarwinData.fromJson(data));
        }
      } else {
        throw Exception('Failed to load reportes by date, status code: ${response.statusCode}');
      }
      return reportes;
    } catch (e) {
      print('Error loading reportes by date: $e');
      throw e;
    }
  }

}
