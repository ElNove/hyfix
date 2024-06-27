import 'package:flutter/material.dart';
import 'package:hyfix/models/Reports.dart';

class DialogEvent extends StatefulWidget {
  const DialogEvent({super.key, required this.report});
  final Reports report;

  @override
  State<DialogEvent> createState() => _DialogEventState();
}

class _DialogEventState extends State<DialogEvent> {
  @override
  Widget build(BuildContext context) {
    Reports rep = widget.report;
    return Center(
      child: AlertDialog(
        title: Text('${rep.customerCode} - ${rep.taskTypeCode}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                const Text(
                  'Tipo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.typeDescription),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Utente: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.signature),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Cliente: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.customerCode),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Luogo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.locationCode),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Progetto: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.projectCode),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Attività: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${rep.projectTaskCode ?? "-"}'),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Tipo Attività: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.taskTypeCode),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Quantita: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    '${int.parse(rep.quantity).toStringAsFixed(2)} ${rep.unityCode}'),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Note Cliente: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(rep.customerNote),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
