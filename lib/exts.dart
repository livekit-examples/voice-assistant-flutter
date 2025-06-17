import 'package:livekit_components/livekit_components.dart' as lk_components;
import 'package:livekit_client/livekit_client.dart' as lk;

extension ParticipantAgentExt on lk.Participant {
  bool get isAgent => kind == lk.ParticipantKind.AGENT;

  lk_components.AgentState? get agentState {
    final str = attributes['lk.agent.state'];
    if (str == null) return lk_components.AgentState.initializing;
    return lk_components.AgentState.fromString(str);
  }
}

extension RoomContextAgentExt on lk_components.RoomContext {
  lk.Participant? get agentParticipant => participants.where((p) => p.isAgent).firstOrNull;
}

extension ParticipantContextAgentExt on lk_components.ParticipantContext {
  
  lk_components.AgentState? get agentState {
    final str = attributes['lk.agent.state'];
    if (str == null) return lk_components.AgentState.initializing;
    return lk_components.AgentState.fromString(str);
  }
}