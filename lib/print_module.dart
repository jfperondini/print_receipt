import 'package:flutter_modular/flutter_modular.dart';
import 'package:print_receipt/ui/receipt/receipt_module.dart';

class PrinterModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: ReceiptModule()),
      ];
}
