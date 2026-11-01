@tool
extends EditorContextMenuPlugin

const TreeText = preload("tree_text.gd")


func _popup_menu(paths: PackedStringArray) -> void:
	if not paths.is_empty():
		add_context_menu_item("ノードツリーをテキストとしてコピー", _copy_tree)


func _copy_tree(nodes: Array) -> void:
	var text := TreeText.format_nodes(nodes, EditorInterface.get_edited_scene_root())
	if not text.is_empty():
		DisplayServer.clipboard_set(text)
