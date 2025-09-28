class ModDiskette {
  final Map<String, dynamic> _data;

  ModDiskette([Map<String, dynamic>? initialData]) : _data = initialData ?? {};

  // Generic getter for any field
  dynamic get(String key) => _data[key];

  // Generic setter for any field
  void set(String key, dynamic value) {
    _data[key] = value;
  }

  // Check if field exists
  bool has(String key) => _data.containsKey(key);

  // Get all data as map
  Map<String, dynamic> toMap() => Map<String, dynamic>.from(_data);

  // Create from map
  factory ModDiskette.fromMap(Map<String, dynamic> map) {
    return ModDiskette(map);
  }

  // Remove a field
  void remove(String key) {
    _data.remove(key);
  }

  // Get all keys
  List<String> get keys => _data.keys.toList();

  @override
  String toString() => 'DisketteData($_data)';
}
