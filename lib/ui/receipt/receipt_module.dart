import 'package:flutter_modular/flutter_modular.dart';
import 'package:print_receipt/ui/receipt/controller/receipt_controller.dart';
import 'package:print_receipt/ui/receipt/view/receipt_presenter.dart';

class ReceiptModule extends Module {
  @override
  final List<Bind> binds = [
    //Controler
    Bind.singleton((i) => ReceiptController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ReceiptPresenter()),
  ];
}
