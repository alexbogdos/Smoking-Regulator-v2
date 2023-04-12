import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableChip extends StatefulWidget {
  const SelectableChip({
    required this.index,
    required this.text,
    required this.minWidth,
    required this.maxWidth,
    required this.height,
    required this.selected,
    required this.background,
    required this.foreground,
    required this.select,
    super.key,
  });

  final int index;
  final String text;

  final double minWidth;
  final double maxWidth;
  final double height;

  final int selected;

  final Color background;
  final Color foreground;

  final void Function(int index) select;

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  bool isSelected() {
    return widget.index == widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isSelected() ? widget.maxWidth : widget.minWidth,
      height: widget.height,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected()
            ? widget.background
            : widget.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: isSelected()
              ? () {}
              : () {
                  widget.select(widget.index);
                },
          borderRadius: BorderRadius.circular(45),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: isSelected() ? FontWeight.w500 : FontWeight.w400,
                color: isSelected()
                    ? widget.foreground
                    : widget.foreground.withOpacity(0.75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
