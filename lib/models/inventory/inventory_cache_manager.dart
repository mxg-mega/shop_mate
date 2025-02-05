import 'package:shop_mate/models/inventory/inventory_item_model.dart';

class InventoryCache {
  static const Duration _cacheDuration = Duration(minutes: 5);
  final Map<String, _CacheEntry> _cache = {};

  void cacheItem(InventoryItem item) {
  _cache[item.id] = _CacheEntry(item: item);
  }

  InventoryItem? getItem(String id){
    final entry = _cache[id];
    if (entry == null || entry.isExpired){
      _cache.remove(id);
      return null;
    }
    return entry.item;
  }

  void clearCache() => _cache.clear();

  void removeFromCache(String id) => _cache.remove(id);
}

class _CacheEntry {
  final InventoryItem item;
  final DateTime expiresAt;

  _CacheEntry({required this.item}) : expiresAt = DateTime.now().add(InventoryCache._cacheDuration);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}