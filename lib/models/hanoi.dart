import 'peg.dart';

class Hanoi {
  List<Peg> pegs;
  List<int> moveRecord;
  List<List<dynamic>> solveMoves;
  int pegsForGame;
  int disksForGame;
  String origin;
  String destination;
  int moveCount;
  bool isShowLevelComplete;
  bool isAuto;
  Hanoi({
    required this.pegs,
    this.moveRecord = const [],
    this.solveMoves = const [],
    required this.pegsForGame,
    required this.disksForGame,
    required this.moveCount,
    required this.origin,
    required this.destination,
    required this.isShowLevelComplete,
    required this.isAuto,
  }) {
    moveRecord = List.filled(0, 0, growable: true);
  }

  void moveDisk(String from, String to) {
    var fromPeg = pegs.firstWhere((peg) => peg.name == from);
    var toPeg = pegs.firstWhere((peg) => peg.name == to);

    if (fromPeg.disks.isNotEmpty &&
        (toPeg.disks.isEmpty || fromPeg.disks.first < toPeg.disks.first)) {
      toPeg.disks.insert(0, fromPeg.disks.removeAt(0));
      moveCount++;
    }
  }

  bool isLevelComplete() {
    var targetPeg = pegs.last;
    return targetPeg.disks.length == disksForGame &&
        targetPeg.disks.every(
          (disk) => disk == targetPeg.disks.indexOf(disk) + 1,
        );
  }

  void resetPegs(List<String> pegsList) {
    pegs = [];
    for (String pegName in pegsList) {
      if (pegName == origin) {
        pegs.add(
          Peg(pegName, List.generate(disksForGame, (index) => index + 1)),
        );
      } else {
        pegs.add(Peg(pegName, []));
      }
    }
    moveCount = 0;
    moveRecord = List.filled(0, 0, growable: true);
  }

  void resetGame(List<String> pegList) {
    isShowLevelComplete = false;
    resetPegs(pegList);
  }

  void setupGame(
    int disks,
    int pegs,
    String origin,
    String destination,
    List<String> pegList,
  ) {
    this.origin = origin;
    this.destination = destination;
    moveCount = 0;
    solveMoves = [];
    moveRecord = [];
    pegsForGame = pegs;
    disksForGame = disks;
    isAuto = false;
    isShowLevelComplete = false;
    resetGame(pegList);
  }

  factory Hanoi.classicGame() {
    return Hanoi(
      pegs: [
        Peg('A', [1, 2, 3]),
        Peg('B', []),
        Peg('C', []),
      ],
      disksForGame: 3,
      pegsForGame: 3,
      moveCount: 0,
      destination: 'C',
      origin: 'A',
      isShowLevelComplete: false,
      isAuto: false,
    );
  }
}
