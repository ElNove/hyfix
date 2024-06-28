import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Service {
  Future<dynamic> getReports(sesid, start, end) async {
    var client = http.Client();


    final startDate = start.toString().split(' ')[0];
    final endDate = end.toString().split(' ')[0];

    Map<String, dynamic> queryParameters = {
      'filters[start]': startDate,
      'filters[end]': endDate,
      'limit': '10000'
    };
    var uri = Uri.https(
        'hyfix.test.nealis.it', '/reports/report/read', queryParameters);
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
