import 'package:print_receipt/domain/model/printer_model.dart';

//Função de repositorie fazer o crud de uma lista de models
abstract class PrinterRepository {
  Future<PrinterModel?> get();
  Future<void> save(PrinterModel printer);
}

class PrinterRepositorySharedPreferences extends PrinterRepository {
  //static const String _keyPrinter = 'selectedPrinter';
  @override
  Future<PrinterModel?> get() async {
    //final prefs = await SharedPreferences.getInstance();
    // final jsonString = prefs.getString(_keyPrinter);
    // if (jsonString != null) {
    //   return PrinterModel.fromJson(jsonDecode(jsonString));
    // } else {
    return null;
    // }
  }

  @override
  Future<void> save(PrinterModel printer) async {
    //final prefs = await SharedPreferences.getInstance();
    //await prefs.setString(_keyPrinter, jsonEncode(printer.toJson()));
  }
}

class PrinterRepositoryCloud extends PrinterRepository {
  @override
  Future<PrinterModel?> get() async {
    //Faz de conta que estamos buscand de uma api
    return null;
  }

  @override
  Future<void> save(PrinterModel printer) async {
    //Faz de conta que estamos salvando de uma api
  }
}
