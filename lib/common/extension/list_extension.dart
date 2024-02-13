extension ListHelpersExtension<E> on Iterable<E> {

  Iterable<E> plus(E element) {
    return [...this, element];
  }
}