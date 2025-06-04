import 'package:flutter/material.dart';

class LayoutSwitcher extends StatelessWidget {
  final bool isFront;
  final Widget Function(BuildContext context) frontBuilder;
  final Widget Function(BuildContext context) backBuilder;

  const LayoutSwitcher({
    super.key,
    this.isFront = true,
    required this.frontBuilder,
    required this.backBuilder,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          backBuilder(context),
          LayoutBuilder(
            builder: (context, constraints) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCirc,
              height: isFront ? constraints.maxHeight : constraints.maxHeight * 0.2,
              child: frontBuilder(context),
            ),
          ),
        ],
      );
}
