import 'package:choo/src/models/common/tree_node.dart';

class NumNode<K> extends TreeNode<K> {
  @override
  final K id;
  NumNode(this.id);
}
