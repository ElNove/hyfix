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
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
      title: Text('${rep.customerCode} - ${rep.taskTypeCode}'),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tipo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.typeDescription,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Utente: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.signature,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cliente: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.customerCode,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Luogo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.locationCode,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progetto: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.projectCode,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attività: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    '${rep.projectTaskCode ?? "-"}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tipo Attività: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    rep.taskTypeCode,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantita: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    '${int.parse(rep.quantity).toStringAsFixed(2)} ${rep.unityCode}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    'Note Cliente: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    softWrap: true,
                    rep.customerNote,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
