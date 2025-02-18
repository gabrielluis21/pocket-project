extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    if (this.isEmpty) {
      return null;
    } else {
      for (T element in this) {
        if (test(element)) {
          return element;
        } else {
          return null;
        }
      }
    }
    return null;
  }
}
