@tool
extends Control

var full_bar: HBoxContainer
var side_panel: VBoxContainer
var content_container: Control
var panels := []

func _enter_tree() -> void:
	if full_bar:    # only build once
		return

	# 1) Build the main bar
	full_bar = HBoxContainer.new()
	full_bar.name = "MainPanel"
	# Stretch to full rect using preset
	full_bar.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	add_child(full_bar)

	# 2) Side panel (tab buttons)
	side_panel = VBoxContainer.new()
	side_panel.name = "SidePanel"
	side_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_panel.set_custom_minimum_size(Vector2(150, 0))
	full_bar.add_child(side_panel)

	# 3) Content area
	content_container = Control.new()
	content_container.name = "ContentContainer"
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	full_bar.add_child(content_container)

	# 4) Harvest any pre-existing children as "panels"
	for child in get_children(false):
		if child != full_bar:
			panels.append(child)

	# 5) Reparent all panels under content_container, hide them
	for panel in panels:
		remove_child(panel)
		content_container.add_child(panel)
		panel.hide()

		# 6) Create a tab button
		var btn = Button.new()
		btn.text = panel.name
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		side_panel.add_child(btn)

		# 7) Connect pressed → _show_panel(panel) using bind()
		var cb = Callable(self, "_show_panel").bind(panel)
		btn.pressed.connect(cb)

	# 8) Show the first panel by default
	if panels.size() > 0:
		_show_panel(panels[0])

func _show_panel(panel_to_show: Node) -> void:
	for panel in panels:
		panel.visible = (panel == panel_to_show)
