import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:print_receipt/domain/model/printer_model.dart';

class ReceiptController extends ChangeNotifier {
  List<PrinterModel> _printers = [];
  PrinterModel? _printer;

  List<PrinterModel> get printers => _printers;
  PrinterModel? get printer => _printer;

  Future<void> initPrinters() async {
    _printers = await scanPrinters();
    _printer = _printers.firstWhere(
      (printer) => printer.deviceName == '',
    );
    notifyListeners();
  }

  Future<void> printSelectedPrinter() async {
    if (_printer != null) {
      var printerManager = PrinterManager.instance;
      printerManager.disconnect(type: _printer!.typePrinter);
      await Future.delayed(const Duration(microseconds: 500));
      await printerManager.connect(
        type: _printer!.typePrinter,
        model: UsbPrinterInput(
          name: _printer!.deviceName,
          productId: _printer!.productId,
          vendorId: _printer!.vendorId,
        ),
      );

      await printBytes(
        qtd: 1,
        printerManager: printerManager,
        bytes: await generateBytesToPrint(),
        printer: _printer!,
      );
    }
  }

  Future<List<int>> generateBytesToPrint() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.reset();
    bytes += generator.text("PEDIDO ",
        styles: const PosStyles(
            height: PosTextSize.size2, width: PosTextSize.size2, fontType: PosFontType.fontA, align: PosAlign.center));

    bytes += generator.text('NOME: ');
    bytes += generator.text('TELEFONE: ');

    bytes += generator.text("---------------------------DOBRE-AQUI---------------------------",
        styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA));

    // Print image

    // Print image using alternative commands

    // Print barcode

    bytes += generator.text('GROCERYLY',
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2),
        linesAfter: 1);

    bytes += generator.text('889  Watson Lane', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('New Braunfels, TX', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: 830-221-1234', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Web: www.example.com', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
      PosColumn(text: 'Total', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: '2', width: 1),
      PosColumn(text: 'ONION RINGS', width: 7),
      PosColumn(text: '0.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '1.98', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(text: '3.45', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '3.45', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(text: '2.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(text: '0.85', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.55', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 6, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2)),
      PosColumn(
          text: '\$10.97',
          width: 6,
          styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size2, width: PosTextSize.size2)),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.row([
      PosColumn(text: 'Cash', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$15.00', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Change', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$4.03', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.reset();

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  Future<void> printBytes({
    required int qtd,
    required PrinterManager printerManager,
    required List<int> bytes,
    required PrinterModel printer,
  }) async {
    await printerManager.connect(
      type: printer.typePrinter,
      model: UsbPrinterInput(
        name: printer.deviceName,
        productId: printer.productId,
        vendorId: printer.vendorId,
      ),
    );

    for (int i = 0; i < qtd; i++) {
      printerManager.send(type: printer.typePrinter, bytes: bytes);
    }
  }

  Future<List<PrinterModel>> scanPrinters(
      {PrinterType defaultPrinterType = PrinterType.usb, bool isBle = false}) async {
    final printerManager = PrinterManager.instance;
    final discoveredDevices = <PrinterModel>[];
    final completer = Completer<List<PrinterModel>>();
    StreamSubscription<PrinterDevice> subscription;

    subscription = printerManager.discovery(type: defaultPrinterType, isBle: isBle).listen((device) {
      discoveredDevices.add(
        PrinterModel(
          deviceName: device.name,
          address: device.address,
          isBle: isBle,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: defaultPrinterType,
        ),
      );
    }, onDone: () => completer.complete(discoveredDevices));

    final devices = await completer.future;
    subscription.cancel();
    return devices;
  }
}
