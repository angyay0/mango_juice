import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/hanoi_view_model.dart';

class HanoiGameOverView extends StatelessWidget {
  const HanoiGameOverView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HanoiViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Game over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations on completing all the levels!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.resetGame(viewModel.pegs.map((m) => m.name).toList());
                Navigator.pop(context);
              },
              child: Text('restart all'),
            ),
          ],
        ),
      ),
    );
  }
}
