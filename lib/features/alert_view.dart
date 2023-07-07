import 'package:flutter/material.dart';

void alertView(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container());
      });
}
