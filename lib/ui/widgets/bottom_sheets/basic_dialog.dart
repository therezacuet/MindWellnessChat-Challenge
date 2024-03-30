
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class BasicDialog extends StatelessWidget {
  final SheetRequest request;
  final Function(DialogResponse) completer;

  const BasicDialog({super.key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          child: Text("Basic"),
        )
    );
  }
}