import '../form.dart';

const String kTreeIdKey = 'id';
const String kTreePidKey = 'pid';
const String kTreeChildrenKey = 'children';

extension IterableExtension<E> on Iterable<E> {
  E? tryFind(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  E? getInitialData<V>({
    E? initialData,
    V? initialValue,
    ValueMapper<E, V?>? valueMapper,
    ValueMapper<E, List<E>?>? childrenMapper,
  }) {
    if (initialData != null) {
      return initialData;
    }

    if (initialValue == null) {
      return null;
    }

    for (E data in this) {
      if ((valueMapper == null ? data : valueMapper(data)) == initialValue) {
        return data;
      }

      if (childrenMapper != null) {
        final children = childrenMapper(data);
        if (children != null && children.isNotEmpty) {
          final result = children.getInitialData(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: valueMapper,
            childrenMapper: childrenMapper,
          );
          if (result != null) {
            return result;
          }
        }
      }
    }
    return null;
  }

  List<E>? getInitialList<V>({
    List<E>? initialData,
    List<V>? initialValue,
    ValueMapper<E, V?>? valueMapper,
    ValueMapper<E, List<E>?>? childrenMapper,
  }) {
    if (initialData != null) {
      return initialData;
    }

    if (initialValue == null) {
      return null;
    }

    final List<E> result = [];
    for (E data in this) {
      if (initialValue
          .contains(valueMapper == null ? data : valueMapper(data))) {
        result.add(data);
      }

      if (childrenMapper != null) {
        final children = childrenMapper(data);
        if (children != null && children.isNotEmpty) {
          final childrenResult = children.getInitialList(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: valueMapper,
            childrenMapper: childrenMapper,
          );
          if (childrenResult != null) {
            result.addAll(childrenResult);
          }
        }
      }
    }
    return result;
  }
}

extension MapIterableExtension on Iterable<Map> {
  /// 将列表转换为树
  Iterable<Map> toTree({
    String idKey = kTreeIdKey,
    String pidKey = kTreePidKey,
    String childrenKey = kTreeChildrenKey,
    String? rootId,
  }) {
    final List<Map> nodes = [...this];

    final Map<String, Map> nodeMap = {};
    for (var node in nodes) {
      nodeMap[node[idKey]] = {...node};
    }

    final List<Map> tree = [];
    for (var node in nodeMap.values) {
      final String? parentId = node[pidKey];
      if (parentId == rootId || parentId == null || parentId.isEmpty) {
        tree.add(node);
      } else {
        // 通过映射表快速找到父节点
        final Map? parentNode = nodeMap[parentId]?.cast<String, dynamic>();
        if (parentNode != null) {
          (parentNode[childrenKey] ??= <Map>[]).add(node);
        }
      }
    }

    return tree;
  }
}
