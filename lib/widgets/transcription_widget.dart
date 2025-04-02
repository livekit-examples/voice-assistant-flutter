// Copyright 2024 LiveKit, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:chat_bubbles/chat_bubbles.dart' show BubbleNormal;
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' show LocalParticipant;

import 'package:livekit_components/livekit_components.dart';

class TranscriptionWidget extends StatelessWidget {
  TranscriptionWidget({
    super.key,
    required this.transcriptions,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  final Color backgroundColor;
  final Color textColor;
  final List<TranscriptionForParticipant> transcriptions;
  final ScrollController _scrollController = ScrollController();

  List<Widget> _buildMessages(
      context, List<TranscriptionForParticipant> transcriptions) {
    List<Widget> msgWidgets = [];
    var sortedTranscriptions = transcriptions
      ..sort((a, b) =>
          a.segment.firstReceivedTime.compareTo(b.segment.firstReceivedTime));
    for (var transcription in sortedTranscriptions) {
      var participant = transcription.participant;
      var segment = transcription.segment;

      if (participant is LocalParticipant) {
        msgWidgets.add(
          BubbleNormal(
            leading: Text(
              participant.identity,
              style: TextStyle(
                color: textColor,
              ),
            ),
            text: segment.text + (segment.isFinal ? '' : '...'),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            tail: true,
            isSender: true,
          ),
        );
      } else {
        msgWidgets.add(Row(
          children: [
            Text(
              segment.text + (segment.isFinal ? '' : '...'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ],
        ));
      }
    }
    return msgWidgets;
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: _buildMessages(context, transcriptions),
            ),
          ),
        ),
      ],
    );
  }
}
