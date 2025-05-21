import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Data class representing the connection details needed to join a LiveKit room
/// This includes the server URL, room name, participant info, and auth token
class ConnectionDetails {
  final String serverUrl;
  final String roomName;
  final String participantName;
  final String participantToken;

  ConnectionDetails({
    required this.serverUrl,
    required this.roomName,
    required this.participantName,
    required this.participantToken,
  });

  factory ConnectionDetails.fromJson(Map<String, dynamic> json) {
    return ConnectionDetails(
      serverUrl: json['serverUrl'],
      roomName: json['roomName'],
      participantName: json['participantName'],
      participantToken: json['participantToken'],
    );
  }
}

/// An example service for fetching LiveKit authentication tokens
///
/// To use the LiveKit Cloud sandbox (development only)
/// - Enable your sandbox here https://cloud.livekit.io/projects/p_/sandbox/templates/token-server
/// - Create .env file with `LIVEKIT_SANDBOX_ID=your_sandbox_id`
///
/// To use a direct LiveKit server URL and a pre-generated token (development or specific use cases)
/// - Set `LIVEKIT_URL=your_livekit_server_url` in your .env file.
/// - Set `LIVEKIT_CLIENT_TOKEN=your_generated_client_token` in your .env file.
///   (Generate a token using the LiveKit CLI: https://docs.livekit.io/home/cli/cli-setup/#generate-access-token)
///   Note: `LIVEKIT_API_KEY` and `LIVEKIT_API_SECRET` are server-side keys for token generation and should not be used directly as client tokens here.
///
/// To use your own token server (production applications)
/// - Add a token endpoint to your server using a LiveKit Server SDK: https://docs.livekit.io/home/server/generating-tokens/
/// - Modify this class or implement a new one to fetch tokens from your server.
///
/// See https://docs.livekit.io/home/get-started/authentication for more information.
class TokenService extends ChangeNotifier {
  // For direct URL/token usage, fetched from .env
  // These will be used if LIVEKIT_SANDBOX_ID is not set or its method fails.
  final String? hardcodedServerUrl = dotenv.env['LIVEKIT_URL']?.replaceAll('"', '');
  // IMPORTANT: Ensure LIVEKIT_CLIENT_TOKEN in .env stores a client-side token.
  // LIVEKIT_API_KEY is a server-side key and typically not used directly on the client.
  // If you intend to use LIVEKIT_API_KEY from .env as a *client token*, this is technically possible but not standard.
  // It's better to generate a specific client token and store it as LIVEKIT_CLIENT_TOKEN.
  final String? hardcodedToken = dotenv.env['LIVEKIT_CLIENT_TOKEN'] ?? dotenv.env['LIVEKIT_API_KEY'];


  // Get the sandbox ID from environment variables
  String? get sandboxId {
    final value = dotenv.env['LIVEKIT_SANDBOX_ID'];
    if (value != null) {
      // Remove unwanted double quotes if present
      return value.replaceAll('"', '');
    }
    return null;
  }

  // LiveKit Cloud sandbox API endpoint
  final String sandboxUrl =
      'https://cloud-api.livekit.io/api/sandbox/connection-details';

  /// Main method to get connection details
  /// First tries hardcoded credentials, then falls back to sandbox
  Future<ConnectionDetails?> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    final hardcodedDetails = fetchHardcodedConnectionDetails(
      roomName: roomName,
      participantName: participantName,
    );

    if (hardcodedDetails != null) {
      return hardcodedDetails;
    }

    return await fetchConnectionDetailsFromSandbox(
      roomName: roomName,
      participantName: participantName,
    );
  }

  Future<ConnectionDetails?> fetchConnectionDetailsFromSandbox({
    required String roomName,
    required String participantName,
  }) async {
    if (sandboxId == null) {
      return null;
    }

    final uri = Uri.parse(sandboxUrl).replace(queryParameters: {
      'roomName': roomName,
      'participantName': participantName,
    });

    try {
      final response = await http.post(
        uri,
        headers: {'X-Sandbox-ID': sandboxId!},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          return ConnectionDetails.fromJson(data);
        } catch (e) {
          debugPrint(
              'Error parsing connection details from LiveKit Cloud sandbox, response: ${response.body}');
          return null;
        }
      } else {
        debugPrint(
            'Error from LiveKit Cloud sandbox: ${response.statusCode}, response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Failed to connect to LiveKit Cloud sandbox: $e');
      return null;
    }
  }

  ConnectionDetails? fetchHardcodedConnectionDetails({
    required String roomName,
    required String participantName,
  }) {
    if (hardcodedServerUrl == null || hardcodedToken == null) {
      return null;
    }

    return ConnectionDetails(
      serverUrl: hardcodedServerUrl!,
      roomName: roomName,
      participantName: participantName,
      participantToken: hardcodedToken!,
    );
  }
}
