import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/peg.dart';
import '../view_models/hanoi_view_model.dart';
import 'disk_widget.dart';

class PegWidget extends StatefulWidget {
  final Peg tower;
  static const List<Color> diskColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  const PegWidget({super.key, required this.tower});

  @override
  State<PegWidget> createState() => _PegWidgetState();
}

class _PegWidgetState extends State<PegWidget>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  bool _isHovering = false;
  AnimationController? _blinkController;
  late Offset? _diskPosition;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HanoiViewModel>(context);

    return DragTarget<Peg>(
      builder: (context, accepted, rejected) {
        return Draggable<Peg>(
          data: widget.tower,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.tower.disks.isNotEmpty)
                    DiskWidget(
                      disk: widget.tower.disks.first,
                      color: PegWidget.diskColors[widget.tower.disks.first - 1],
                    ),
                  Text(
                    widget.tower.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "RobotoMono-SemiBold",
                    ),
                  ),
                ],
              ),
            ),
          ),
          onDragStarted: () {
            setState(() {
              _isDragging = true;
              if (widget.tower.disks.isNotEmpty) {
                _diskPosition = Offset.zero;
              }
            });
          },
          onDragEnd: (details) {
            setState(() {
              _isDragging = false;
              _diskPosition = null;
            });
          },
          child: Container(
            width: 100,
            height: 300,
            decoration: BoxDecoration(
              color: _isDragging
                  ? Colors.grey.withAlpha((0.3 * 255).toInt())
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(width: 10, height: 200, color: Colors.grey),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.tower.disks.map((disk) {
                          return DiskWidget(
                            disk: disk,
                            color: PegWidget.diskColors[disk - 1],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18, width: 16),
                Container(
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isHovering
                        ? Colors.lightGreen.withAlpha(160)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.tower.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "RobotoMono-SemiBold",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (DragTargetDetails<Peg> details) {
        final incomingPeg = details.data;
        if (incomingPeg.disks.isEmpty) return false;
        final movingDisk = incomingPeg.disks.first;
        bool canAccept =
            widget.tower.disks.isEmpty || movingDisk < widget.tower.disks.last;
        if (canAccept && widget.tower.name != incomingPeg.name) {
          setState(() {
            _isHovering = true;
          });
        }
        return canAccept;
      },
      onAcceptWithDetails: (DragTargetDetails<Peg> details) {
        final incomingPeg = details.data;
        viewModel.moveDisk(incomingPeg.name, widget.tower.name);
        setState(() {
          _isHovering = false;
        });
      },
      onLeave: (data) {
        setState(() {
          _isHovering = false;
        });
      },
    );
  }
}
