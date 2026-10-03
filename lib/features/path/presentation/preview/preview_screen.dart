import 'package:flutter/material.dart';

import '../../domain/entities/grid.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/point.dart';

abstract class _GridColors {
  static const Color start = Color(0xFF64FFDA);
  static const Color end = Color(0xFF009688);
  static const Color blocked = Color(0xFF000000);
  static const Color path = Color(0xFF4CAF50);
  static const Color empty = Color(0xFFFFFFFF);
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.result});

  final PathResult result;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Grid grid = result.task.grid;

    return Scaffold(
      appBar: AppBar(title: const Text('Route details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double cellSize = constraints.maxWidth / grid.width;
              final double gridHeight = cellSize * grid.height;
              final Set<Point> pathCells = result.steps.toSet();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: InteractiveViewer(
                        constrained: false,
                        minScale: 0.18,
                        maxScale: 12,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: gridHeight,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: grid.width * grid.height,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: grid.width,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final Point point = grid.pointAt(index);
                              final Color color = point == result.task.start
                                  ? _GridColors.start
                                  : point == result.task.end
                                  ? _GridColors.end
                                  : grid.isBlocked(point)
                                  ? _GridColors.blocked
                                  : pathCells.contains(point)
                                  ? _GridColors.path
                                  : _GridColors.empty;
                              final double fontSize = (cellSize * 0.24)
                                  .clamp(1.0, 12.0)
                                  .toDouble();

                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: color,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    point.toString(),
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: color == _GridColors.blocked
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Shortest route',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        result.hasPath ? result.pathString : 'No path found',
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _LegendItem(color: _GridColors.start, label: 'Start'),
                      _LegendItem(color: _GridColors.end, label: 'End'),
                      _LegendItem(color: _GridColors.path, label: 'Path'),
                      _LegendItem(color: _GridColors.blocked, label: 'Blocked'),
                      _LegendItem(color: _GridColors.empty, label: 'Free'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              border: color == _GridColors.empty
                  ? Border.all(color: Colors.black12)
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
