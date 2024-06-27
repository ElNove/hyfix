// To parse this JSON data, do
//
//     final reportSave = reportSaveFromJson(jsonString);

import 'dart:convert';

ReportSave reportSaveFromJson(String str) =>
    ReportSave.fromJson(json.decode(str));

String reportSaveToJson(ReportSave data) => json.encode(data.toJson());

class ReportSave {
  dynamic id;
  String reportType;
  DateTime reportDate;
  dynamic projectId;
  String defaultProject;
  dynamic projectTaskId;
  dynamic taskTypeId;
  String taskTypeCode;
  int quantity;
  int customerQuantity;
  String note;
  String customerNote;
  String userId;
  String receiverUserId;
  String signature;
  String username;
  String signatureReceiver;
  String bill;
  String billed;
  String refund;
  String refunded;
  String reportPrint;
  String unityCode;
  String unityType;
  String reportUnityType;
  String assigned;
  String assignee;
  int userBlocked;
  bool isReportManager;

  ReportSave({
    required this.id,
    required this.reportType,
    required this.reportDate,
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
    required this.receiverUserId,
    required this.signature,
    required this.username,
    required this.signatureReceiver,
    required this.bill,
    required this.billed,
    required this.refund,
    required this.refunded,
    required this.reportPrint,
    required this.unityCode,
    required this.unityType,
    required this.reportUnityType,
    required this.assigned,
    required this.assignee,
    required this.userBlocked,
    required this.isReportManager,
  });

  factory ReportSave.fromJson(Map<String, dynamic> json) => ReportSave(
        id: json["id"],
        reportType: json["report_type"],
        reportDate: DateTime.parse(json["report_date"]),
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
        receiverUserId: json["receiver_user_id"],
        signature: json["signature"],
        username: json["username"],
        signatureReceiver: json["signature_receiver"],
        bill: json["bill"],
        billed: json["billed"],
        refund: json["refund"],
        refunded: json["refunded"],
        reportPrint: json["report_print"],
        unityCode: json["unity_code"],
        unityType: json["unity_type"],
        reportUnityType: json["report_unity_type"],
        assigned: json["assigned"],
        assignee: json["assignee"],
        userBlocked: json["user_blocked"],
        isReportManager: json["is_report_manager"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_type": reportType,
        "report_date":
            "${reportDate.year.toString().padLeft(4, '0')}-${reportDate.month.toString().padLeft(2, '0')}-${reportDate.day.toString().padLeft(2, '0')}",
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
        "receiver_user_id": receiverUserId,
        "signature": signature,
        "username": username,
        "signature_receiver": signatureReceiver,
        "bill": bill,
        "billed": billed,
        "refund": refund,
        "refunded": refunded,
        "report_print": reportPrint,
        "unity_code": unityCode,
        "unity_type": unityType,
        "report_unity_type": reportUnityType,
        "assigned": assigned,
        "assignee": assignee,
        "user_blocked": userBlocked,
        "is_report_manager": isReportManager,
      };
}
