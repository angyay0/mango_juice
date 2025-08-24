import 'package:flutter/material.dart';
import '../components/alert_dialog.dart';
import 'peg_widget.dart';
import 'package:provider/provider.dart';

import '../view_models/hanoi_view_model.dart';

class HanoiGameView extends StatefulWidget {
  const HanoiGameView({super.key});

  @override
  State<HanoiGameView> createState() => _HanoiGameViewState();
}

class _HanoiGameViewState extends State<HanoiGameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Torres de Hanoi',
          style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () =>
                Navigator.pushNamed(context, '/level_config').then((onValue) {
                  setState(() {});
                }),
          ),
          Consumer<HanoiViewModel>(
            builder: (_, vm, __) => IconButton(
              tooltip: 'Resolver (API)',
              icon: const Icon(Icons.play_arrow),
              onPressed: vm.isAuto ? null : () => vm.startAutoSolve(),
            ),
          ),
        ],
      ),
      body: Consumer<HanoiViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isShowLevelComplete && !viewModel.dialogShown) {
            viewModel.dialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialogWidget(viewModel: viewModel),
              ).then((_) {
                viewModel.dialogShown = false;
              });
            });
          }

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discos,Torres: ${viewModel.disksForGame},${viewModel.pegsForGame}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoMono-SemiBold",
                          ),
                        ),
                        Text(
                          'Movs: ${viewModel.moveCount}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoMono-SemiBold",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: viewModel.pegs.map((tower) {
                          return PegWidget(tower: tower);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
