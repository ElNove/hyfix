import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hyfix/WeeksDay.dart';

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
      String sesid,
      dynamic start,
      dynamic end,
      String type,
      dynamic customer,
      dynamic location,
      dynamic project,
      dynamic projectTask,
      dynamic taskType,
      dynamic user) async {
    var client = http.Client();

    final startDate = start.toString().split(' ')[0];
    final endDate = end.toString().split(' ')[0];

    Map<String, dynamic> queryParameters = {
      'filters[start]': startDate,
      'filters[end]': endDate,
      'filters[report_type]': type,
      /*'filters[customer_id]': customer,
      'filters[location_id]': location,
      'filters[project_id]': project,
      'filters[project_task_id]': projectTask,
      'filters[task_type_id]': taskType,
      'filters[user_id]': user,*/
      '_limit': '10000'
    };
    if (customer != "") {
      for (var element in customer) {
        print(element);
        // queryParameters.
        queryParameters.addAll({'filters[customer_id][]': "$element"});
        print(queryParameters);
      }
    }
    if (location != "") {
      for (var element in location) {
        queryParameters.addAll({'filters[location_id][]': "$element"});
      }
    }
    if (project != "") {
      for (var element in project) {
        queryParameters.addAll({'filters[project_id][]': "$element"});
      }
    }
    if (projectTask != "") {
      for (var element in projectTask) {
        queryParameters.addAll({'filters[project_task_id][]': "$element"});
      }
    }
    if (taskType != "") {
      for (var element in taskType) {
        queryParameters.addAll({'filters[task_type_id][]': "$element"});
      }
    }
    if (user != "") {
      for (var element in user) {
        queryParameters.addAll({'filters[user_id][]': "$element"});
      }
    }
    print(queryParameters);
    var uri = Uri.https(
        'hyfix.test.nealis.it', '/reports/report/read', queryParameters);
    var response = await client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });
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

  Future<http.Response> selectRead({
    required String sesid,
    required String tipo,
    dynamic report_type,
    dynamic customer_id,
    dynamic project_id,
    dynamic task_type_id,
    dynamic location_id,
    dynamic project_task_id,
    dynamic user_id,
  }) async {
    DateTime focusedDay = DateTime.now();

    List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

    final startDate = weeks.first.first.toString().split(' ')[0];
    final endDate = weeks.last.last.toString().split(' ')[0];

    var params;
    switch (tipo) {
      case "C":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[location_id]": location_id ?? '',
          "filters[project_id]": project_id ?? '',
          "filters[project_task_id]": project_task_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "filters[user_id]": user_id ?? '',
          "selectParams[distinctFields][]": [
            "customer_id",
            "customer_code",
            "customer_companyname"
          ]
        };
        break;
      case "L":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[customer_id]": customer_id ?? '',
          "filters[project_id]": project_id ?? '',
          "filters[project_task_id]": project_task_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "filters[user_id]": user_id ?? '',
          "selectParams[distinctFields][]": [
            "location_id",
            "location_code",
            "location_city"
          ]
        };
        break;
      case "P":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[customer_id]": customer_id ?? '',
          "filters[location_id]": location_id ?? '',
          "filters[project_task_id]": project_task_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "filters[user_id]": user_id ?? '',
          "selectParams[distinctFields][]": [
            "project_id",
            "project_code",
            "customer_code"
          ]
        };
        break;
      case "A":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[customer_id]": customer_id ?? '',
          "filters[location_id]": location_id ?? '',
          "filters[project_id]": project_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "filters[user_id]": user_id ?? '',
          "selectParams[distinctFields][]": [
            "project_task_id",
            "project_task_code",
            "project_code",
            "customer_code"
          ]
        };

        break;
      case "TA":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[customer_id]": customer_id ?? '',
          "filters[location_id]": location_id ?? '',
          "filters[project_id]": project_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "filters[user_id]": user_id ?? '',
          "selectParams[distinctFields][]": [
            "task_type_id",
            "task_type_code",
            "unity_code"
          ]
        };
        break;
      case "U":
        params = {
          "filters[start]": startDate,
          "filters[end]": endDate,
          "filters[customer_id]": customer_id ?? '',
          "filters[location_id]": location_id ?? '',
          "filters[project_id]": project_id ?? '',
          "filters[project_task_id]": project_task_id ?? '',
          "filters[task_type_id]": task_type_id ?? '',
          "selectParams[distinctFields][]": [
            "user_id",
            "username",
            "signature",
            "avatar"
          ]
        };
        break;
    }
    if (tipo != "A") {
      var uri = Uri.https(
          'hyfix.test.nealis.it', '/reports/report/selectread', params);
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.cookieHeader: sesid,
        },
      );

      return response;
    } else {
      var uri = Uri.https('hyfix.test.nealis.it',
          '/reports/report/readdistinctprojecttasks', params);
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.cookieHeader: sesid,
        },
      );

      return response;
    }
  }
}
