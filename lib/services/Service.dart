import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hyfix/Home.dart';
import 'package:hyfix/models/Reports.dart';

class Service {
  Future<dynamic> getReports(sesid) async {
    var client = http.Client();

    var uri = Uri.https('hyfix.test.nealis.it', '/reports/report/read');
    var response = await client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    if (response.body.contains('"success":true')) {
      var json = response.body;
      final jsonData = jsonDecode(json);
      return jsonData['data'];
    } else {
      throw Exception('Failed to load report');
    }
  }
}
