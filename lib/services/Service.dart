import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Service {
  Future<http.Response> fetchUtente(String user, String password) async {
    final queryParameters = {
      'username': user,
      'password': password,
    };
    final uri =
        Uri.https('hyfix.test.nealis.it', '/auth/login', queryParameters);
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    return response;
  }

  Future<dynamic> getReports(
      {required String sesid,
      required dynamic start,
      required dynamic end,
      required String type,
      List? customer,
      List? location,
      List? project,
      List? projectTask,
      List? taskType,
      List? user}) async {
    var client = http.Client();

    final startDate = start.toString().split(' ')[0];
    final endDate = end.toString().split(' ')[0];

    Map<String, dynamic> queryParameters = {
      'filters[start]': startDate,
      'filters[end]': endDate,
      'filters[report_type]': type,
      'filters[customer_id]': customer ?? '',
      'filters[location_id]': location ?? '',
      'filters[project_id]': project ?? '',
      'filters[project_task_id]': projectTask ?? '',
      'filters[task_type_id]': taskType ?? '',
      'filters[user_id]': user ?? '',
      'limit': '10000'
    };
    var uri = Uri.https(
        'hyfix.test.nealis.it', '/reports/report/read', queryParameters);
    var response = await client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    print(response.body);
    print(sesid);
    if (response.body.contains('"success":true')) {
      var json = response.body;
      final dynamic jsonData = jsonDecode(json);
      return jsonData['data'];
    } else {
      return false;
    }
  }

  Future<bool> logout(String sesid) async {
    var client = http.Client();

    var uri = Uri.https('hyfix.test.nealis.it', '/auth/logout');
    await client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    }).onError((error, stackTrace) {
      throw Exception('Failed to logout');
    });

    return true;
  }

  Future<http.Response> getUtente(String sesid) async {
    final uri = Uri.https('hyfix.test.nealis.it', '/auth/user/read');

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    return response;
  }

  Future<http.Response> getClienti(String sesid, int id) async {
    final params = {
      'filters[id]': '$id',
    };
    final Uri uri;
    if (id == 0) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customer/read');
    } else {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customer/read', params);
    }
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    return response;
  }

  Future<http.Response> getProgetti(
      String sesid, int id, Map<String, dynamic> cliente) async {
    final params = {
      "filters[customer_id]": '$id',
    };
    final Uri uri;
    if (cliente.isEmpty) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/project/readactive');
    } else {
      uri = Uri.https(
          'hyfix.test.nealis.it', '/reports/project/readactive', params);
    }

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );

    return response;
  }

  Future<http.Response> getLuoghi(String sesid, int id) async {
    final params = {
      'filters[customer_id]': '$id',
    };

    final Uri uri;
    if (id == 0) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customerlocation/read');
    } else {
      uri = Uri.https(
          'hyfix.test.nealis.it', '/reports/customerlocation/read', params);
    }
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );

    return response;
  }

  Future<http.Response> getResolve(
      String sesid, Map<String, Object> params) async {
    final Uri uri;
    uri = Uri.https('hyfix.test.nealis.it', '/reports/report/resolve', params);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );

    return response;
  }

  Future<http.Response> getActivity(
      {required String sesid,
      required String cate,
      int? pr_id,
      int? cu_id,
      required String defaultPr}) async {
    final Uri uri;
    if (cate == "T" && defaultPr == "N") {
      final params = {
        'filters[project_id]': pr_id.toString(),
        'filters[unity_type]': cate,
        'filters[customer_id]': cu_id.toString(),
      };
      uri = Uri.https('hyfix.test.nealis.it',
          '/reports/projecttask/readactivewithactiveproject', params);
    } else {
      final params = {
        'filters[unity_type]': cate,
      };
      uri = Uri.https('hyfix.test.nealis.it', '/reports/tasktype/read', params);
    }

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );

    return response;
  }

  Future<http.Response> saveReport(String sesid, String rep) async {
    var uri = Uri.https('hyfix.test.nealis.it', '/reports/report/save');
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': sesid,
        },
        body: rep);

    return response;
  }
}
