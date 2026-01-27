// ignore_for_file: unused_field

import 'serverpod_client_service.dart';

class CollectionService {
  CollectionService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Future<void> createCollection(String name) async {
    // TODO: Implement when endpoints are ready.
  }
}
