// ignore_for_file: unused_field

import 'serverpod_client_service.dart';

class ChatService {
  ChatService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    // TODO: Implement chat endpoint call.
  }
}
