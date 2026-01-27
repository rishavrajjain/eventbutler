import 'package:flutter/foundation.dart';

import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider({ChatService? chatService})
    : _chatService = chatService ?? ChatService();

  final ChatService _chatService;

  bool _sending = false;

  bool get isSending => _sending;

  Future<void> sendMessage(String roomId, String text) async {
    _sending = true;
    notifyListeners();
    try {
      await _chatService.sendMessage(roomId: roomId, text: text);
    } finally {
      _sending = false;
      notifyListeners();
    }
  }
}
