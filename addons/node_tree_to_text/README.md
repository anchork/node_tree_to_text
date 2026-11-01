# Node Tree to Text

シーンツリーで右クリックしたノードと、その子孫をテキストにしてクリップボードにコピーする Godot 4.4 以降向けのエディターアドオンです。

## 使い方

1. `addons/node_tree_to_text` フォルダーをプロジェクトに配置します。このプロジェクトには配置・有効化済みです。
2. **プロジェクト → プロジェクト設定 → プラグイン** で **Node Tree to Text** を有効にします。
3. シーンツリーで対象のノードを右クリックし、**ノードツリーをテキストとしてコピー** を選びます。
4. テキストエディターやチャットなどに貼り付けます。

```text
Fields/N/Table [Node3D]
├── ToRadio [FieldButton3DStarter]
│   └── CameraMove [CameraMove]
└── Radio [Field3D]
    ├── Switch [Node3DEntity]
    │   └── TransformCompo [Node]
    └── SwitchOffButton [FieldButton3DStarter]
```

- 各行は `ノード名 [クラス名]` です。先頭行のみ、編集中のシーンのルート名からのパスを表示します。
- クラス名には、アタッチしたスクリプトの `class_name` を優先します。未定義の場合は継承元の `class_name`、それもなければ `Node3D` などの組み込みクラス名を表示します。
- 子ノードを折りたたんでいても、インスタンス化したシーンの子を含め、子孫をツリー順に出力します。エンジン内部用ノードは除外します。
- 複数選択にも対応します。ツリーごとに空行を入れ、親と子の両方を選んだ場合は重複を除きます。
- プロパティ値や注釈は出力しません。

Godot の公式 `EditorContextMenuPlugin` API を使用します。
https://docs.godotengine.org/en/4.6/classes/class_editorcontextmenuplugin.html

## 開発時の検証

このリポジトリのルートで次を実行すると、出力形式・カスタムクラス名・複数選択のテストを実行できます。

```sh
godot --headless --path . --script tests/test_tree_text.gd
```
