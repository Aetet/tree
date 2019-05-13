import 'package:choo/src/models/common/tree_node.dart';
import 'package:choo/src/models/typedefs.dart';
import 'package:choo/src/services/common/tree_node_adapter.dart';
import 'package:choo/src/mixins/tree_service_mixin.dart';

typedef Build<N extends TreeNode> = Object Function(MultiTreeBuilder<N> k);

class MultiTree<N extends TreeNode> extends Tree<N> with TreeServiceMixin<N> {
  final Map<N, Set<N>> _nodes;
  N _rootNode;

  MultiTree(this._nodes, this._rootNode);

  @override
  N getRootNode() {
    return _rootNode;
  }

  Iterable<N> getParents(N node) {
    if (node == _rootNode) return [];
    if (node == null) return [];
    final result = <N>[];
    _nodes.forEach((key, nodeSet) {
      if (nodeSet.contains(node)) {
        result.add(key);
      }
    });

    return result;
  }

  @override
  Iterable<N> getChildren(N node) {
    return _nodes[node] ?? [];
  }

  @override
  N getDefaultNode(N node) {
    return (node == null) ? _rootNode : node;
  }

  MultiTree<N> rebuild(Build<N> b) {
    final builder = new MultiTreeBuilder<N>(this);
    b(builder);
    return builder.build();
  }
}

class MultiTreeBuilder<N extends TreeNode> {
  MultiTree<N> _tree;
  MultiTreeBuilder(MultiTree<N> tree) {
    _tree = _makeTreeCopy(tree);
  }

  MultiTreeBuilder<N> sort(Sorter<N> sort) {
    final _nodes = <N, Set<N>>{};
    final node = _tree.getRootNode();
    _sortInner(_nodes, node, sort);
    this._tree = MultiTree(_nodes, node);

    return this;
  }

  void _sortInner(Map<N, Set<N>> nodes, N node, Sorter<N> sort) {
    final iterToSort = _tree.getChildren(node);
    final list = List.of(iterToSort, growable: false);

    list.sort(sort);
    nodes[node] = list.toSet();

    iterToSort.forEach((child) {
      _sortInner(nodes, child, sort);
    });
  }

  MultiTree<N> _makeTreeCopy(MultiTree<N> tree) {
    final newNodes = <N, Set<N>>{};
    tree._nodes.forEach((k, v) {
      newNodes[k] = v.toSet();
    });
    return MultiTree<N>(newNodes, tree._rootNode);
  }

  MultiTree<N> build() {
    return _tree;
  }

  MultiTreeBuilder<N> removeNodesFromParent(Iterable<N> nodes, N parentNode) {
    final nodesToUpdate = _tree._nodes[parentNode];
    nodesToUpdate.removeAll(nodes);

    return this;
  }

  MultiTreeBuilder<N> attachNodesToParent(Iterable<N> nodes, N parentNode) {
    final nodesToUpdate = _tree._nodes[parentNode];
    nodesToUpdate.addAll(nodes);

    return this;
  }

  MultiTreeBuilder<N> moveNodes(Iterable<N> nodes, N from, N to) {
    removeNodesFromParent(nodes, from);
    attachNodesToParent(nodes, to);
    return this;
  }
}
