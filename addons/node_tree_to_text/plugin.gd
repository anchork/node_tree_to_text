@tool
extends EditorPlugin

const SceneTreeMenu = preload("scene_tree_menu.gd")

var _context_menu: EditorContextMenuPlugin


func _enter_tree() -> void:
	_context_menu = SceneTreeMenu.new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCENE_TREE, _context_menu)


func _exit_tree() -> void:
	if _context_menu != null:
		remove_context_menu_plugin(_context_menu)
		_context_menu = null
