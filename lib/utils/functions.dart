class Functions {
  static String getValue(Map<int, String> map, int key) {
    return map[key] ?? '';
  }
}