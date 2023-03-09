import 'package:flutter/material.dart';

class TableDivider extends StatelessWidget {
  const TableDivider({
    required this.width,
    required this.height,
    required this.color,
    super.key,
  });

  final double width;
  final double height;

  final Color color;

  final double radius = 45;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
