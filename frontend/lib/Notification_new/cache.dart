import 'dart:typed_data';
import 'dart:convert';

class ImageCache {
  final Map<String, Uint8List> _cache = {};

  Uint8List? get(String key) => _cache[key];

  void put(String key, Uint8List value) {
    _cache[key] = value;
  }
}

final imageCache = ImageCache();
