import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/widgets/more_page/history_view/time_card.dart';

class HistoryList extends StatelessWidget {
  HistoryList({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.items,
  });

  final double width;
  final double height;

  final List items;

  final Color text;

  // "${items.length - index}th ${items[index]}"

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      // color: Colors.white,
      // alignment: Alignment.topCenter,
      child: items.isNotEmpty
          ? ListView.builder(
              itemCount: items.length,
              controller: scrollController,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return TimeCard(
                  key: ValueKey(index),
                  index: index,
                  width: width,
                  items: items,
                  text: text,
                );
              },
            )
          : Align(
              alignment: const Alignment(0, -0.7),
              child: Text(
                "No cigarettes\nsmoked today",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: text,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
    );
  }
}
