import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/hanoi.dart';
import '../models/peg.dart';

class HanoiViewModel extends ChangeNotifier {
  final Hanoi _gameModel;

  HanoiViewModel(this._gameModel);

  List<Peg> get pegs => _gameModel.pegs;
  List<int> get moveRecord => _gameModel.moveRecord;
  int get disksForGame => _gameModel.disksForGame;
  int get pegsForGame => _gameModel.pegsForGame;
  int get moveCount => _gameModel.moveCount;
  bool get isShowLevelComplete => _gameModel.isShowLevelComplete;

  set isShowLevelComplete(bool state) => _gameModel.isShowLevelComplete = state;

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
