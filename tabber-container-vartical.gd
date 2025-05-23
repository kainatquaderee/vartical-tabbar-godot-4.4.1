@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("v-tabbar-container","Container", preload("v-tabbar-container.gd"), preload("v-tab-container.png"))


func _exit_tree() -> void:
	remove_custom_type("v-tabbar-container")
