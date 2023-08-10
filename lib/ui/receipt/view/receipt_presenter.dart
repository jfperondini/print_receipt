import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:print_receipt/ui/receipt/controller/receipt_controller.dart';

class ReceiptPresenter extends StatefulWidget {
  const ReceiptPresenter({super.key});

  @override
  State<ReceiptPresenter> createState() => _ReceiptPresenterState();
}

class _ReceiptPresenterState extends State<ReceiptPresenter> {
  final receiptController = Modular.get<ReceiptController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final vendaConcluidaController = context.read<ReceiptController>();

                    // Inicializando a lista de impressoras
                    await vendaConcluidaController.initPrinters();

                    // Imprimindo na impressora selecionada
                    await vendaConcluidaController.printSelectedPrinter();
                  },
                  child: const Text('Imprimir')),
            ],
          ),
        ],
      ),
    );
  }
}
