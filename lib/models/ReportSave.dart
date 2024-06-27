// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ReportSave ReportSaveFromJson(String str) => ReportSave.fromJson(json.decode(str));

String ReportSaveToJson(ReportSave data) => json.encode(data.toJson());

class ReportSave {
    int id;
    String reportType;
    DateTime reportDate;
    int customerId;
    int customerLocationId;
    String customerCode;
    int locationId;
    String locationCode;
    String locationFulladdress;
    String locationDistance;
    int projectId;
    String defaultProject;
    int projectTaskId;
    int taskTypeId;
    String taskTypeCode;
    int quantity;
    int customerQuantity;
    String note;
    String customerNote;
    int userId;
    String signature;
    String username;
    String bill;
    String billed;
    String refund;
    String refunded;
    String reportPrint;
    String unityCode;
    String unityType;
    String reportUnityType;
    int userBlocked;
    String locationCity;
    String customerCompanyname;
    String locationAddress;
    String locationZip;
    String locationProvince;
    String locationCountry;
    String projectCode;
    String projectExpire;
    String projectActive;
    int unityId;

    ReportSave({
        required this.id,
        required this.reportType,
        required this.reportDate,
        required this.customerId,
        required this.customerLocationId,
        required this.customerCode,
        required this.locationId,
        required this.locationCode,
        required this.locationFulladdress,
        required this.locationDistance,
        required this.projectId,
        required this.defaultProject,
        required this.projectTaskId,
        required this.taskTypeId,
        required this.taskTypeCode,
        required this.quantity,
        required this.customerQuantity,
        required this.note,
        required this.customerNote,
        required this.userId,
        required this.signature,
        required this.username,
        required this.bill,
        required this.billed,
        required this.refund,
        required this.refunded,
        required this.reportPrint,
        required this.unityCode,
        required this.unityType,
        required this.reportUnityType,
        required this.userBlocked,
        required this.locationCity,
        required this.customerCompanyname,
        required this.locationAddress,
        required this.locationZip,
        required this.locationProvince,
        required this.locationCountry,
        required this.projectCode,
        required this.projectExpire,
        required this.projectActive,
        required this.unityId,
    });

    factory ReportSave.fromJson(Map<String, dynamic> json) => ReportSave(
        id: json["id"],
        reportType: json["report_type"],
        reportDate: DateTime.parse(json["report_date"]),
        customerId: json["customer_id"],
        customerLocationId: json["customer_location_id"],
        customerCode: json["customer_code"],
        locationId: json["location_id"],
        locationCode: json["location_code"],
        locationFulladdress: json["location_fulladdress"],
        locationDistance: json["location_distance"],
        projectId: json["project_id"],
        defaultProject: json["default_project"],
        projectTaskId: json["project_task_id"],
        taskTypeId: json["task_type_id"],
        taskTypeCode: json["task_type_code"],
        quantity: json["quantity"],
        customerQuantity: json["customer_quantity"],
        note: json["note"],
        customerNote: json["customer_note"],
        userId: json["user_id"],
        signature: json["signature"],
        username: json["username"],
        bill: json["bill"],
        billed: json["billed"],
        refund: json["refund"],
        refunded: json["refunded"],
        reportPrint: json["report_print"],
        unityCode: json["unity_code"],
        unityType: json["unity_type"],
        reportUnityType: json["report_unity_type"],
        userBlocked: json["user_blocked"],
        locationCity: json["location_city"],
        customerCompanyname: json["customer_companyname"],
        locationAddress: json["location_address"],
        locationZip: json["location_zip"],
        locationProvince: json["location_province"],
        locationCountry: json["location_country"],
        projectCode: json["project_code"],
        projectExpire: json["project_expire"],
        projectActive: json["project_active"],
        unityId: json["unity_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "report_type": reportType,
        "report_date": "${reportDate.year.toString().padLeft(4, '0')}-${reportDate.month.toString().padLeft(2, '0')}-${reportDate.day.toString().padLeft(2, '0')}",
        "customer_id": customerId,
        "customer_location_id": customerLocationId,
        "customer_code": customerCode,
        "location_id": locationId,
        "location_code": locationCode,
        "location_fulladdress": locationFulladdress,
        "location_distance": locationDistance,
        "project_id": projectId,
        "default_project": defaultProject,
        "project_task_id": projectTaskId,
        "task_type_id": taskTypeId,
        "task_type_code": taskTypeCode,
        "quantity": quantity,
        "customer_quantity": customerQuantity,
        "note": note,
        "customer_note": customerNote,
        "user_id": userId,
        "signature": signature,
        "username": username,
        "bill": bill,
        "billed": billed,
        "refund": refund,
        "refunded": refunded,
        "report_print": reportPrint,
        "unity_code": unityCode,
        "unity_type": unityType,
        "report_unity_type": reportUnityType,
        "user_blocked": userBlocked,
        "location_city": locationCity,
        "customer_companyname": customerCompanyname,
        "location_address": locationAddress,
        "location_zip": locationZip,
        "location_province": locationProvince,
        "location_country": locationCountry,
        "project_code": projectCode,
        "project_expire": projectExpire,
        "project_active": projectActive,
        "unity_id": unityId,
    };
}
