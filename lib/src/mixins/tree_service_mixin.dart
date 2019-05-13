import 'package:choo/src/models/common/traverse_context.dart';
import 'package:choo/src/models/common/tree_node.dart';
import 'package:choo/src/models/typedefs.dart';
import 'package:choo/src/services/common/tree_node_adapter.dart';

mixin TreeServiceMixin<T extends TreeNode> on Tree<T> {
  Iterable<T> flatten([T startNode]) {
    final result = <T>[];

    traverse((node, counter) {
      result.add(node);
    });

    return result;
  }

  // This should be side-effect free method.
  // We only traverse without tree modification
  // For modification use Builder
  void traverse(Traverse<T> func, {T node, int endIndex}) {
    final context = TraverseContext()
      ..endIndex = endIndex
      ..counter = 0;
    _traverse(node == null ? getRootNode() : node, func, context);
  }

  T getElementAt(int index, [T startNode]) {
    T lastElem;
    int lastIndex;
    traverse((node, counter) {
      lastElem = node;
      lastIndex = counter;
    }, endIndex: index);
    if (index > lastIndex) {
      lastElem = null;
    }

    return lastElem;
  }

  void _traverse(T node, Traverse<T> func, TraverseContext context) {
    final endIndex = context.endIndex;
    final counter = context.counter;
    if (node == null) return;
    if (endIndex != null && counter > endIndex) return;
    func(node, counter);
    if (endIndex != null) context.counter++;
    final children = getChildren(node);
    children.forEach((childNode) {
      _traverse(childNode, func, context);
    });
  }
}
