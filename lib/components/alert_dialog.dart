import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../view_models/hanoi_view_model.dart';

class AlertDialogWidget extends StatelessWidget {
  final HanoiViewModel viewModel;

  const AlertDialogWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> steps = viewModel.moves;
    final showSteps = (steps != null && steps!.isNotEmpty);
    print(steps);

    return AlertDialog(
      title: Text(
        showSteps ? 'Pasos para resolver' : '¡Completado!',
        style: const TextStyle(fontFamily: "RobotoMono-SemiBold"),
      ),
      content: Column(
        spacing: 10,
        children: [
          Text(
            'Movimientos: ${viewModel.moveCount}',
            style: const TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
          _StepsContent(steps: steps),
        ],
      ),
      actions: [
        if (showSteps)
          TextButton.icon(
            onPressed: () async {
              final jsonString = jsonEncode(steps);
              await Clipboard.setData(ClipboardData(text: jsonString));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copiado al portapapeles')),
                );
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar JSON'),
          ),
        TextButton(
          onPressed: () {
            viewModel.resetGame(viewModel.pegs.map((m) => m.name).toList());
            viewModel.isShowLevelComplete = false;
            Navigator.of(context).pop();
          },
          child: const Text(
            'Reiniciar',
            style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
        ),
      ],
    );
  }
}

class _StepsContent extends StatelessWidget {
  final List<List<dynamic>> steps;
  const _StepsContent({required this.steps});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.5;
    final maxWidth = MediaQuery.of(context).size.width * 0.9;

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            final disk = step[0];
            final from = step[1];
            final to = step[2];
            return SelectableText(
              "Paso ${index + 1}: Disco $disk de $from → $to",
              style: const TextStyle(fontFamily: 'RobotoMono-SemiBold'),
            );
          },
        ),
      ),
    );
  }
}
