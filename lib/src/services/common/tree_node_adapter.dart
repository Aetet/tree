import 'package:choo/src/models/common/tree_node.dart';

abstract class Tree<T extends TreeNode> {
  Iterable<T> getChildren(T node);
  Iterable<T> getParents(T node);
  T getRootNode();
  T getDefaultNode(T node);
}
