import 'package:flutter/material.dart';

import '../ui/color_pallette.dart';

class MessageBarButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool isEnabled;

  const MessageBarButton({
    super.key,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext ctx) => ClipOval(
        child: Material(
          color: isEnabled ? Theme.of(ctx).buttonTheme.colorScheme?.surface : LKColorPaletteDark().bg3,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      );
}

class MessageBar extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onSendTap;
  final bool isSendEnabled;

   const MessageBar({
    super.key,
    this.controller,
    this.focusNode,
    this.isSendEnabled = true,
    this.onSendTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Message...',
                ),
                minLines: 1,
                maxLines: 3,
              ),
            ),
            MessageBarButton(
              isEnabled: isSendEnabled,
              onTap: onSendTap,
            )
          ],
        ),
      );
}
