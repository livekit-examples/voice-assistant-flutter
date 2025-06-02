import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

class FloatingGlassView extends StatelessWidget {
  final Widget child;
  const FloatingGlassView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext ctx) => ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 1,
                color: Theme.of(ctx).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: child,
          ),
        ),
      );
}

class FloatingGlassButton extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback? onTap;
  final Color? iconColor;

  final Widget? subWidget;

  const FloatingGlassButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.subWidget,
  });

  @override
  Widget build(BuildContext ctx) => Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: _buildContent(ctx),
          ),
        ),
      );

  Widget _buildContent(BuildContext context) {
    if (subWidget != null) {
      return Row(
        children: [
          Icon(icon, color: iconColor),
          subWidget!,
        ],
      );
    }

    return Icon(icon, color: iconColor);
  }
}
