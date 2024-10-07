extension ListHelpersExtension<E> on Iterable<E> {
  Iterable<E> plus(E element) {
    return [...this, element];
  }

  bool enCommun(Iterable<E> list) {
    // Utiliser Set pour vérifier s'il existe des éléments en commun
    final Set<E> set1 = toSet();
    for (E element in list) {
      if (set1.contains(element)) {
        return true; // Il y a un élément commun
      }
    }
    return false; // Aucun élément commun
  }
}
