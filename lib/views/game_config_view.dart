import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/hanoi_view_model.dart';
import 'dart:math';

List<String> generateLabels(int k) {
  const base = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final labels = <String>[];
  var i = 0;
  while (labels.length < k) {
    if (i < 26) {
      labels.add(base[i]);
    } else {
      labels.add(base[i % 26] + (i ~/ 26).toString());
    }
    i++;
  }
  return labels;
}

class GameConfigView extends StatefulWidget {
  final int initialDisks;
  final int initialPegs;
  final int maxDisks;
  final int maxPegs;

  const GameConfigView({
    super.key,
    this.initialDisks = 3,
    this.initialPegs = 3,
    this.maxDisks = 12,
    this.maxPegs = 8,
  });

  @override
  State<GameConfigView> createState() => _GameConfigViewState();
}

class _GameConfigViewState extends State<GameConfigView> {
  late int _disks;
  late int _pegs;
  late List<TextEditingController> _labelCtrls;
  late HanoiViewModel viewModel;

  String _from = '';
  String _to = '';

  @override
  void initState() {
    super.initState();
    _disks = max(1, min(widget.initialDisks, widget.maxDisks));
    _pegs = max(3, min(widget.initialPegs, widget.maxPegs));
    final labels = generateLabels(_pegs);
    _labelCtrls = labels.map((e) => TextEditingController(text: e)).toList();
    _from = labels.first;
    _to = labels.last;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<HanoiViewModel>(context, listen: false);
    });
  }

  @override
  void dispose() {
    for (final c in _labelCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> get _effectiveLabels {
    return generateLabels(_pegs);
  }

  String? _validate() {
    if (_disks < 1) return 'Debe haber al menos 1 disco.';
    if (_pegs < 3) return 'Debe haber al menos 3 torres.';
    final labels = _effectiveLabels;
    if (labels.length != _pegs) return 'Cantidad de etiquetas inválida.';
    if (labels.any((e) => e.isEmpty))
      return 'Las etiquetas no pueden estar vacías.';
    if (labels.toSet().length != labels.length)
      return 'Las etiquetas deben ser únicas.';
    if (!labels.contains(_from)) return 'La torre de origen no es válida.';
    if (!labels.contains(_to) || _to == _from)
      return 'La torre de destino no es válida o coincide con origen.';
    return null;
  }

  void _apply() {
    List<String> labels = _labelCtrls.map((item) => item.text).toList();
    viewModel.setupGame(_disks, _pegs, _from, _to, labels);
    Navigator.pop(context);
  }

  void _onPegsChanged(int value) {
    setState(() {
      _pegs = value;
      final labels = generateLabels(_pegs);
      for (final c in _labelCtrls) {
        c.dispose();
      }
      _labelCtrls = labels.map((e) => TextEditingController(text: e)).toList();
      _from = labels.first;
      _to = labels.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = _effectiveLabels;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.only(left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Configurar Torre de Hanoi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Discos
            Row(
              children: [
                const Text('Discos'),
                Expanded(
                  child: Slider(
                    value: _disks.toDouble(),
                    min: 1,
                    max: widget.maxDisks.toDouble(),
                    divisions: widget.maxDisks - 1,
                    label: '$_disks',
                    onChanged: (v) => setState(() => _disks = v.round()),
                  ),
                ),
                Text('$_disks'),
              ],
            ),

            // Pegs
            Row(
              children: [
                const Text('Torres'),
                Expanded(
                  child: Slider(
                    value: _pegs.toDouble(),
                    min: 3,
                    max: widget.maxPegs.toDouble(),
                    divisions: widget.maxPegs - 3,
                    label: '$_pegs',
                    onChanged: (v) => _onPegsChanged(v.round()),
                  ),
                ),
                Text('$_pegs'),
              ],
            ),
            const SizedBox(height: 8),

            // From / To selectors
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: labels.contains(_from)
                        ? _from
                        : (labels.isNotEmpty ? labels.first : null),
                    decoration: const InputDecoration(labelText: 'Origen'),
                    items: labels
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _from = v ?? _from),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: labels.contains(_to) && _to != _from
                        ? _to
                        : (labels.length > 1 ? labels.last : null),
                    decoration: const InputDecoration(labelText: 'Destino'),
                    items: labels
                        //.where((e) => e != _from)
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _to = v ?? _to),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Apply
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _apply,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Jugar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class GameConfigView extends StatefulWidget {
  const GameConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configura las torres de Hanoi',
          style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
        ),
      ),
      body: ListView.builder(
        itemCount: viewModel.maxLevel,
        itemBuilder: (context, index) {
          final level = index + 1;
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'level $level',
                  style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
                ),
                if (viewModel.currentLevel >= level &&
                    viewModel.moveRecord[level] > 0)
                  Text(
                    'least move count ${viewModel.moveRecord[level]}',
                    style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
                  ),
              ],
            ),
            enabled: level <= viewModel.unlockedLevels,
            onTap: () {
              viewModel.setLevel(level);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
*/
