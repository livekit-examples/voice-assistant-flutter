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
  final bool isActive;
  final bool isEnabled;

  final Widget? subWidget;

  const FloatingGlassButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.isActive = false,
    this.isEnabled = true,
    this.subWidget,
  });

  @override
  Widget build(BuildContext ctx) => Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        child: Ink(
          color: isActive ? Theme.of(ctx).cardColor.withOpacity(0.2) : null,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              alignment: Alignment.center,
              child: _buildContent(ctx),
            ),
          ),
        ),
      );

  Widget _buildContent(BuildContext context) {
    if (subWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          subWidget!,
        ],
      );
    }

    return Opacity(
      opacity: onTap == null ? 0.1 : 1.0,
      child: Icon(icon, color: iconColor),
    );
  }
}
