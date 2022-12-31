import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator({
    super.key,
    required this.count,
    required this.current,
    this.width = 10,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> indicator = <Widget>[];
    for (int i = 0; i < count; i++) {
      indicator.add(
        Icon(
          i == (current ?? 0) ? Icons.circle : Icons.circle_outlined,
          size: width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicator,
    );
  }
}
