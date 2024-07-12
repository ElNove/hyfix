// To parse this JSON data, do
//
//     final reports = reportsFromJson(jsonString);

import 'dart:convert';

List<Reports> reportsFromJson(String str) =>
    List<Reports>.from(json.decode(str).map((x) => Reports.fromJson(x)));

String reportsToJson(List<Reports> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reports {
  int id;
  String reportType;
  DateTime reportDate;
  int customerId;
  int locationId;
  int userId;
  String note;
  String customerNote;
  int projectId;
  dynamic projectTaskId;
  int taskTypeId;
  String quantity;
  String customerQuantity;
  String bill;
  String refund;
  String refunded;
  String reportPrint;
  String billed;
  dynamic blockdate;
  DateTime start;
  dynamic blocked;
  String typeDescription;
  String customerCode;
  String customerCompanyname;
  String locationCode;
  String locationAddress;
  String locationZip;
  String locationCity;
  String locationProvince;
  String locationCountry;
  String locationDistance;
  String locationFulladdress;
  int customerLocationId;
  String username;
  String signature;
  String avatar;
  String projectCode;
  String projectDescription;
  dynamic projectExpire;
  String defaultProject;
  int projectPosition;
  int projectPositionNotZero;
  dynamic projectTaskCode;
  dynamic projectTaskDescription;
  dynamic projectTaskExpire;
  dynamic projectTaskEstimate;
  dynamic projectTaskPosition;
  dynamic projectTaskPositionNotZero;
  String taskTypeCode;
  int unityId;
  String taskTypeBill;
  String taskTypeRefund;
  String taskTypeReportPrint;
  String taskTypeColor;
  String color;
  String unityCode;
  String unityType;
  DateTime firstOfTheMonth;
  int userBlocked;
  String title;

  Reports({
    required this.id,
    required this.reportType,
    required this.reportDate,
    required this.customerId,
    required this.locationId,
    required this.userId,
    required this.note,
    required this.customerNote,
    required this.projectId,
    required this.projectTaskId,
    required this.taskTypeId,
    required this.quantity,
    required this.customerQuantity,
    required this.bill,
    required this.refund,
    required this.refunded,
    required this.reportPrint,
    required this.billed,
    required this.blockdate,
    required this.start,
    required this.blocked,
    required this.typeDescription,
    required this.customerCode,
    required this.customerCompanyname,
    required this.locationCode,
    required this.locationAddress,
    required this.locationZip,
    required this.locationCity,
    required this.locationProvince,
    required this.locationCountry,
    required this.locationDistance,
    required this.locationFulladdress,
    required this.customerLocationId,
    required this.username,
    required this.signature,
    required this.avatar,
    required this.projectCode,
    required this.projectDescription,
    required this.projectExpire,
    required this.defaultProject,
    required this.projectPosition,
    required this.projectPositionNotZero,
    required this.projectTaskCode,
    required this.projectTaskDescription,
    required this.projectTaskExpire,
    required this.projectTaskEstimate,
    required this.projectTaskPosition,
    required this.projectTaskPositionNotZero,
    required this.taskTypeCode,
    required this.unityId,
    required this.taskTypeBill,
    required this.taskTypeRefund,
    required this.taskTypeReportPrint,
    required this.taskTypeColor,
    required this.color,
    required this.unityCode,
    required this.unityType,
    required this.firstOfTheMonth,
    required this.userBlocked,
    required this.title,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        id: json["id"],
        reportType: json["report_type"],
        reportDate: DateTime.parse(json["report_date"]),
        customerId: json["customer_id"],
        locationId: json["location_id"],
        userId: json["user_id"],
        note: json["note"],
        customerNote: json["customer_note"],
        projectId: json["project_id"],
        projectTaskId: json["project_task_id"],
        taskTypeId: json["task_type_id"],
        quantity: json["quantity"],
        customerQuantity: json["customer_quantity"],
        bill: json["bill"],
        refund: json["refund"],
        refunded: json["refunded"],
        reportPrint: json["report_print"],
        billed: json["billed"],
        blockdate: json["blockdate"],
        start: DateTime.parse(json["start"]),
        blocked: json["blocked"],
        typeDescription: json["type_description"],
        customerCode: json["customer_code"],
        customerCompanyname: json["customer_companyname"],
        locationCode: json["location_code"],
        locationAddress: json["location_address"],
        locationZip: json["location_zip"],
        locationCity: json["location_city"],
        locationProvince: json["location_province"],
        locationCountry: json["location_country"],
        locationDistance: json["location_distance"],
        locationFulladdress: json["location_fulladdress"],
        customerLocationId: json["customer_location_id"],
        username: json["username"],
        signature: json["signature"],
        avatar: json["avatar"],
        projectCode: json["project_code"],
        projectDescription: json["project_description"],
        projectExpire: json["project_expire"],
        defaultProject: json["default_project"],
        projectPosition: json["project_position"],
        projectPositionNotZero: json["project_position_not_zero"],
        projectTaskCode: json["project_task_code"],
        projectTaskDescription: json["project_task_description"],
        projectTaskExpire: json["project_task_expire"],
        projectTaskEstimate: json["project_task_estimate"],
        projectTaskPosition: json["project_task_position"],
        projectTaskPositionNotZero: json["project_task_position_not_zero"],
        taskTypeCode: json["task_type_code"],
        unityId: json["unity_id"],
        taskTypeBill: json["task_type_bill"],
        taskTypeRefund: json["task_type_refund"],
        taskTypeReportPrint: json["task_type_report_print"],
        taskTypeColor: json["task_type_color"],
        color: json["color"],
        unityCode: json["unity_code"],
        unityType: json["unity_type"],
        firstOfTheMonth: DateTime.parse(json["first_of_the_month"]),
        userBlocked: json["user_blocked"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_type": reportType,
        "report_date":
            "${reportDate.year.toString().padLeft(4, '0')}-${reportDate.month.toString().padLeft(2, '0')}-${reportDate.day.toString().padLeft(2, '0')}",
        "customer_id": customerId,
        "location_id": locationId,
        "user_id": userId,
        "note": note,
        "customer_note": customerNote,
        "project_id": projectId,
        "project_task_id": projectTaskId,
        "task_type_id": taskTypeId,
        "quantity": quantity,
        "customer_quantity": customerQuantity,
        "bill": bill,
        "refund": refund,
        "refunded": refunded,
        "report_print": reportPrint,
        "billed": billed,
        "blockdate": blockdate,
        "start":
            "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}",
        "blocked": blocked,
        "type_description": typeDescription,
        "customer_code": customerCode,
        "customer_companyname": customerCompanyname,
        "location_code": locationCode,
        "location_address": locationAddress,
        "location_zip": locationZip,
        "location_city": locationCity,
        "location_province": locationProvince,
        "location_country": locationCountry,
        "location_distance": locationDistance,
        "location_fulladdress": locationFulladdress,
        "customer_location_id": customerLocationId,
        "username": username,
        "signature": signature,
        "avatar": avatar,
        "project_code": projectCode,
        "project_description": projectDescription,
        "project_expire": projectExpire,
        "default_project": defaultProject,
        "project_position": projectPosition,
        "project_position_not_zero": projectPositionNotZero,
        "project_task_code": projectTaskCode,
        "project_task_description": projectTaskDescription,
        "project_task_expire": projectTaskExpire,
        "project_task_estimate": projectTaskEstimate,
        "project_task_position": projectTaskPosition,
        "project_task_position_not_zero": projectTaskPositionNotZero,
        "task_type_code": taskTypeCode,
        "unity_id": unityId,
        "task_type_bill": taskTypeBill,
        "task_type_refund": taskTypeRefund,
        "task_type_report_print": taskTypeReportPrint,
        "task_type_color": taskTypeColor,
        "color": color,
        "unity_code": unityCode,
        "unity_type": unityType,
        "first_of_the_month":
            "${firstOfTheMonth.year.toString().padLeft(4, '0')}-${firstOfTheMonth.month.toString().padLeft(2, '0')}-${firstOfTheMonth.day.toString().padLeft(2, '0')}",
        "user_blocked": userBlocked,
        "title": title,
      };
}
