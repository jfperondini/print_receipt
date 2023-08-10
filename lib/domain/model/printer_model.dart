import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class PrinterModel {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;
  PrinterType typePrinter;
  bool? state;

  String printerTypeToString() {
    switch (typePrinter) {
      case PrinterType.bluetooth:
        return "bluetooth";
      case PrinterType.network:
        return "network";
      case PrinterType.usb:
        return "usb";
    }
  }

  static PrinterType stringToPrinterType(String typePrinter) {
    switch (typePrinter) {
      case "bluetooth":
        return PrinterType.bluetooth;
      case "network":
        return PrinterType.network;
      case "usb":
        return PrinterType.usb;

      default:
        return PrinterType.bluetooth;
    }
  }

  PrinterModel({this.id, this.deviceName, this.address, this.port, this.state, this.vendorId, this.productId, this.typePrinter = PrinterType.bluetooth, this.isBle = false});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'deviceName': deviceName,
      'address': address,
      'port': port,
      'vendorId': vendorId,
      'productId': productId,
      'isBle': isBle,
      'typePrinter': printerTypeToString(),
      'state': state,
    };
  }

  factory PrinterModel.fromJson(Map<String, dynamic> map) {
    return PrinterModel(
      id: map["id"] ?? 0,
      deviceName: map["deviceName"] ?? "",
      address: map["address"] ?? "",
      isBle: map["isBle"] ?? false,
      port: map["port"] ?? "",
      productId: map["productId"] ?? "",
      state: map["state"] ?? false,
      typePrinter: stringToPrinterType(map["typePrinter"] ?? ""),
      vendorId: map["vendorId"] ?? "",
    );
  }
}
