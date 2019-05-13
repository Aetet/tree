abstract class TreeNode<K> {
  K id;

  @override
  bool operator ==(other) {
    if (other is! TreeNode<K>) return false;
    return other.id == id;
  }

  @override
  String toString() {
    return id?.toString();
  }

  @override
  int get hashCode => id?.hashCode;
}
