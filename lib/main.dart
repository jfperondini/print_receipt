import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:print_receipt/print_module.dart';
import 'package:print_receipt/print_widget.dart';

void main() async {
  runApp(ModularApp(module: PrinterModule(), child: const PrintApp()));
}
