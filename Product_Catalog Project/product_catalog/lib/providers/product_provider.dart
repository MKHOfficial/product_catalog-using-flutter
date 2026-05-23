import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filtered = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _filtered;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  List<Product> get favorites => _allProducts.where((p) => p.isFavorite).toList();

  // Load all products from local SQLite — fast single query
  Future<void> fetchProducts() async {
    if (_allProducts.isNotEmpty) return; // already loaded — skip
    _isLoading = true;
    notifyListeners();

    _allProducts = await DatabaseService.getProducts();

    // Build category list without duplicates
    final seen = <String>{};
    final cats = <String>['All'];
    for (final p in _allProducts) {
      if (seen.add(p.category)) cats.add(p.category);
    }
    _categories = cats;

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  // Search — real time, instant
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Category filter
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Apply filters — runs in memory, no DB call
  void _applyFilters() {
    _filtered = _allProducts.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery) ||
          p.category.toLowerCase().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }

  // Toggle favorite — in memory + SQLite
  void toggleFavorite(int id) {
    final idx = _allProducts.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    _allProducts[idx].isFavorite = !_allProducts[idx].isFavorite;
    DatabaseService.updateFavorite(id, _allProducts[idx].isFavorite);
    notifyListeners();
  }
}
