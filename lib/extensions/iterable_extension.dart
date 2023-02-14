extension IterableExtension<E> on Iterable<E> {
  E? tryFind(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
