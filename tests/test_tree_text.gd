extends SceneTree

const TreeText = preload("res://addons/node_tree_to_text/tree_text.gd")
const Field = preload("res://tests/fixtures/field.gd")
const InheritedField = preload("res://tests/fixtures/inherited_field.gd")

var _failures := 0


func _initialize() -> void:
	_run_tests.call_deferred()


func _run_tests() -> void:
	var fields := Node3D.new()
	fields.name = "Fields"
	root.add_child(fields)
	var north := _add(fields, Node3D.new(), "N")
	var table := _add(north, Node3D.new(), "Table")
	var to_radio := _add(table, Node.new(), "ToRadio")
	_add(to_radio, Node.new(), "CameraMove")
	var radio := _add(table, Field.new(), "Radio")
	var switch := _add(radio, Node3D.new(), "Switch")
	_add(switch, Node.new(), "TransformCompo")
	_add(radio, InheritedField.new(), "SwitchOffButton")
	var internal := Node.new()
	internal.name = "Internal"
	table.add_child(internal, false, Node.INTERNAL_MODE_BACK)

	var expected := "\n".join(PackedStringArray([
		"Fields/N/Table [Node3D]",
		"├── ToRadio [Node]",
		"│   └── CameraMove [Node]",
		"└── Radio [NodeTreeToTextTestField]",
		"    ├── Switch [Node3D]",
		"    │   └── TransformCompo [Node]",
		"    └── SwitchOffButton [NodeTreeToTextTestField]",
	]))
	_check("tree branches, paths, custom/inherited classes, internal children",
		TreeText.format_nodes([table], fields), expected)
	_check("overlapping selections and duplicates",
		TreeText.format_nodes([radio, table, table, to_radio], fields), expected)
	_check("multiple roots follow scene order",
		TreeText.format_nodes([radio, to_radio], fields),
		"Fields/N/Table/ToRadio [Node]\n└── CameraMove [Node]\n\n"
		+ "Fields/N/Table/Radio [NodeTreeToTextTestField]\n"
		+ "├── Switch [Node3D]\n│   └── TransformCompo [Node]\n"
		+ "└── SwitchOffButton [NodeTreeToTextTestField]")
	_check("leaf node", TreeText.format_nodes([switch.get_child(0)]), "TransformCompo [Node]")
	_check("scene root label", TreeText.format_nodes([fields], fields).get_slice("\n", 0),
		"Fields [Node3D]")
	_check("empty selection", TreeText.format_nodes([]), "")
	var deleted := Node.new()
	deleted.free()
	_check("stale selection", TreeText.format_nodes([deleted, null]), "")
	fields.free()
	if _failures == 0:
		print("PASS: all node tree formatting checks")
	quit(1 if _failures > 0 else 0)


func _add(parent: Node, child: Node, node_name: String) -> Node:
	child.name = node_name
	parent.add_child(child)
	return child


func _check(label: String, actual: String, expected: String) -> void:
	if actual != expected:
		_failures += 1
		push_error("%s\nExpected:\n%s\nActual:\n%s" % [label, expected, actual])
