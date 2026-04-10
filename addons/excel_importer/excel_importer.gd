@tool
extends EditorPlugin

var dock

func _enter_tree() -> void:
	dock = load("res://addons/excel_importer/excel_importer_dock.tscn").instantiate()
	if !ProjectSettings.has_setting("lib/master/resource_input_path"):
		ProjectSettings.set_setting("lib/master/resource_input_path", "res://resource/input")
		ProjectSettings.save()
	if !ProjectSettings.has_setting("lib/master/resource_output_path"):
		ProjectSettings.set_setting("lib/master/resource_output_path", "res://resource/output")
		ProjectSettings.save()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)

func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
