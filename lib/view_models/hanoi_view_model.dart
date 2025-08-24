import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/hanoi.dart';
import '../models/peg.dart';
import '../models/repository/hanoi_steps.dart';

class HanoiViewModel extends ChangeNotifier {
  final Hanoi _gameModel;

  HanoiViewModel(this._gameModel);

  List<Peg> get pegs => _gameModel.pegs;
  List<int> get moveRecord => _gameModel.moveRecord;
  int get disksForGame => _gameModel.disksForGame;
  int get pegsForGame => _gameModel.pegsForGame;
  int get moveCount => _gameModel.moveCount;
  bool get isShowLevelComplete => _gameModel.isShowLevelComplete;
  bool get isAuto => _gameModel.isAuto;

  set isShowLevelComplete(bool state) => _gameModel.isShowLevelComplete = state;
  set isAuto(bool state) => _gameModel.isAuto = state;

  bool _dialogShown = false;
  bool get dialogShown => _dialogShown;
  set dialogShown(bool v) {
    _dialogShown = v;
    notifyListeners();
  }

  /* Auto Solve con la API */
  final Duration _autoStep = const Duration(milliseconds: 250);
  List<List<dynamic>> moves = [];
  int _moveIndex = 0;

  Future<void> startAutoSolve() async {
    if (isAuto) return;
    isAuto = true;
    notifyListeners();

    try {
      List<String> labels = _gameModel.pegs.map((m) => m.name).toList();
      Map<String, dynamic> body;
      body = {
        "size": disksForGame,
        "k": _gameModel.pegsForGame,
        "pegs": labels,
        "from": _gameModel.origin,
        "to": _gameModel.destination,
      };

      // Obtiene la solucion desde el API
      final steps = await stepsForSolveHanoi(body);

      if (steps is! List) {
        isAuto = false;
        notifyListeners();
        return;
      }

      moves = steps.cast<List>();
      _moveIndex = 0;

      resetGame(labels);

      // Cada paso es [disk(int), from(str), to(str)]
      while (isAuto && _moveIndex < moves.length) {
        final step = moves[_moveIndex];
        moveDisk(step[1], step[2]);
        _moveIndex++;
        notifyListeners();
        await Future.delayed(_autoStep);
      }

      isAuto = false;
      notifyListeners();
    } catch (_) {
      isAuto = false;
      notifyListeners();
    }
  }

  Future<void> moveDisk(String from, String to) async {
    _gameModel.moveDisk(from, to);
    final player = AudioPlayer();
    await player.play(AssetSource('fast-simple-chop.mp3'));
    if (_gameModel.isLevelComplete()) {
      final player = AudioPlayer();
      await player.play(AssetSource('level-up.mp3'));
      _gameModel.isShowLevelComplete = true;
    }
    notifyListeners();
  }

  void resetGame(List<String> pegList) {
    _gameModel.resetGame(pegList);
    notifyListeners();
  }

  void navigateToGameOver() {}

  void setupGame(
    int disks,
    int pegs,
    String origin,
    String destination,
    List<String> pegList,
  ) {
    _gameModel.setupGame(disks, pegs, origin, destination, pegList);
  }
}
