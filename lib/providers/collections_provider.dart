// ignore_for_file: unused_field

import 'package:flutter/foundation.dart';

import '../services/collection_service.dart';

class CollectionsProvider extends ChangeNotifier {
  CollectionsProvider({CollectionService? collectionService})
    : _collectionService = collectionService ?? CollectionService();

  final CollectionService _collectionService;

  bool _loading = false;
  List<dynamic> _collections = [];
  String? _error;

  bool get isLoading => _loading;
  List<dynamic> get collections => _collections;
  String? get error => _error;

  Future<void> loadCollections() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      // TODO: replace with service call
      _collections = [];
    } catch (e) {
      _error = 'Could not load collections';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
