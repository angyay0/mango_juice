import 'package:flutter/material.dart';
import '../view_models/hanoi_view_model.dart';

class AlertDialogWidget extends StatelessWidget {
  final HanoiViewModel viewModel;
  const AlertDialogWidget({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Completado!',
        style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
      ),
      content: Text(
        'Movimientos: ${viewModel.moveCount}',
        style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            viewModel.resetGame(viewModel.pegs.map((m) => m.name).toList());
            viewModel.isShowLevelComplete = false;
            Navigator.of(context).pop();
          },
          child: Text(
            'Reiniciar',
            style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
        ),
        TextButton(
          onPressed: () {
            viewModel.isShowLevelComplete = false;
            Navigator.of(context).pop();
          },
          child: Text(
            'Nuevo nivel',
            style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
        ),
      ],
    );
  }
}
