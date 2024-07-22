import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _searchQuery = '';
  final List<String> _searchHistory = [];

  String get searchQuery => _searchQuery;
  List<String> get searchHistory => _searchHistory;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addSearchHistory(String query) {
    if (!_searchHistory.contains(query) && query.isNotEmpty) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 5) {
        // Limit history to 5 items
        _searchHistory.removeLast();
      }
    }
    notifyListeners();
  }
}
