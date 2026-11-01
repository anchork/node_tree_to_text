# Node Tree to Text

An editor addon for Godot 4.4 and later that turns the node you right-click in the Scene tree, along with all of its descendants, into text and copies it to the clipboard.

## Usage

1. Place the `addons/node_tree_to_text` folder in your project. It is already installed and enabled in this project.
2. Enable **Node Tree to Text** in **Project → Project Settings → Plugins**.
3. Right-click the target node in the Scene tree and choose **Copy node tree to clipboard**.
4. Paste it into a text editor, a chat window, or anywhere else.

```text
Fields/N/Table [Node3D]
├── ToRadio [FieldButton3DStarter]
│   └── CameraMove [CameraMove]
└── Radio [Field3D]
    ├── Switch [Node3DEntity]
    │   └── TransformCompo [Node]
    └── SwitchOffButton [FieldButton3DStarter]
```

- Each line is formatted as `node name [class name]`. Only the first line shows the path from the root name of the scene being edited.
- For the class name, the `class_name` of the attached script takes priority. If it is undefined, the `class_name` of the parent class is used, and if that is also undefined, the built-in class name such as `Node3D` is shown.
- Even if child nodes are collapsed, descendants are output in tree order, including the children of instanced scenes. Internal engine nodes are excluded.
- Multi-selection is supported. A blank line separates each tree, and when both a parent and its child are selected, duplicates are removed.
- Property values and annotations are not output.

This addon uses Godot's official `EditorContextMenuPlugin` API.
https://docs.godotengine.org/en/4.6/classes/class_editorcontextmenuplugin.html

## Verifying during development

Run the following from the root of this repository to run the tests for output formatting, custom class names, and multi-selection.

```sh
godot --headless --path . --script tests/test_tree_text.gd
```
