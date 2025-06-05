import 'package:flutter/material.dart';

/// Button shown when disconnected to start a new conversation
class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isProgressing;
  final String text;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isProgressing = false,
  });

  @override
  Widget build(BuildContext ctx) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(ctx).buttonTheme.colorScheme?.surface,
          foregroundColor: Theme.of(ctx).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isProgressing) const CircularProgressIndicator.adaptive(),
            Text(
              text.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

