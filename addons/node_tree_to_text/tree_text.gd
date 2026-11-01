@tool
extends RefCounted
## Formats scene nodes without modifying the scene or including editor-internal children.


static func format_nodes(nodes: Array, scene_root: Node = null) -> String:
	var roots: Array[Node] = []
	for value in nodes:
		if is_instance_valid(value) and value is Node and not roots.has(value):
			roots.append(value)

	# A selected descendant is already included in its selected ancestor's tree.
	var top_roots: Array[Node] = []
	for node in roots:
		var covered := false
		for other in roots:
			if other != node and other.is_ancestor_of(node):
				covered = true
				break
		if not covered:
			top_roots.append(node)
	top_roots.sort_custom(func(a: Node, b: Node) -> bool: return not a.is_greater_than(b))

	var trees := PackedStringArray()
	for node in top_roots:
		var label := String(node.name)
		if scene_root != null and scene_root.is_ancestor_of(node):
			label = "%s/%s" % [scene_root.name, scene_root.get_path_to(node)]
		var lines := PackedStringArray(["%s [%s]" % [label, _class_name_for(node)]])
		_append_children(node, "", lines)
		trees.append("\n".join(lines))
	return "\n\n".join(trees)


static func _append_children(node: Node, prefix: String, lines: PackedStringArray) -> void:
	var children := node.get_children()
	for index in range(children.size()):
		var child: Node = children[index]
		var last := index == children.size() - 1
		var branch := "└── " if last else "├── "
		lines.append("%s%s%s [%s]" % [prefix, branch, child.name, _class_name_for(child)])
		_append_children(child, prefix + ("    " if last else "│   "), lines)


static func _class_name_for(node: Node) -> String:
	var script: Script = node.get_script()
	while script != null:
		var global_name := String(script.get_global_name())
		if not global_name.is_empty():
			return global_name
		script = script.get_base_script()
	return node.get_class()
