import 'package:flutter/material.dart';

class RebuildCounter extends StatefulWidget {
  final String label;
  final Widget child;

  const RebuildCounter({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  State<RebuildCounter> createState() => _RebuildCounterState();
}

class _RebuildCounterState extends State<RebuildCounter> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (_buildCount > 0)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber.shade700, width: 0.5),
              ),
              child: Text(
                '$_buildCount',
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
            ),
          ),
      ],
    );
  }
}
