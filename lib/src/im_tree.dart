import 'package:choo/src/models/nodes/num_node.dart';
import 'package:choo/src/services/multi_tree/multi_tree.dart';

void main() {
  final tree = MultiTree<NumNode<int>>({
    NumNode(1): {NumNode(2), NumNode(5)},
    NumNode(2): {NumNode(10)},
    NumNode(10): {},
    NumNode(5): {NumNode(10)},
  }, NumNode(1));

  final newTree = tree.rebuild((b) {
    b.sort((a, b) {
      return a.id.compareTo(b.id);
    }).removeNodesFromParent({NumNode(10)}, NumNode(5));
  });

  final flattenTree = newTree.flatten();
  print('flatten: ${flattenTree}');
/*
  print('-------------');
  print('traverse: ');
  tree.traverse((node, counter) {
    print(node);
  });
  print('-------------');

  final node = tree.getElementAt(7);
  print('element at: $node');
  // flattenTree.first.mappy();

  // print('newTree: ${newTree}');
  */
}
