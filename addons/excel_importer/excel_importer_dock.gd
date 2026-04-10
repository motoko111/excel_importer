@tool
extends Control

@export var import_btn:Button = null
@export var export_enum_btn:Button = null
@export var convert_enum_to_excel_btn:Button = null
@export var convert_enum_target_file_regex_edit:LineEdit = null
var resource_input_path:String:
	set(v):
		ProjectSettings.set_setting("lib/master/resource_input_path", v)
		ProjectSettings.save()
	get():
		return ProjectSettings.get_setting("lib/master/resource_input_path", "res://resource/input")
var resource_output_path:String:
	set(v):
		ProjectSettings.set_setting("lib/master/resource_output_path", v)
		ProjectSettings.save()
	get():
		return ProjectSettings.get_setting("lib/master/resource_output_path", "res://resource/output")
var enum_json_output_path:String:
	set(v):
		ProjectSettings.set_setting("lib/master/enum_json_output_path", v)
		ProjectSettings.save()
	get():
		return ProjectSettings.get_setting("lib/master/enum_json_output_path", "res://resource/enum/enum_list.json")
var convert_enum_target_file_regex:String:
	set(v):
		ProjectSettings.set_setting("lib/master/convert_enum_target_file_regex", v)
		ProjectSettings.save()
	get():
		return ProjectSettings.get_setting("lib/master/convert_enum_target_file_regex", ".*")

func _enter_tree() -> void:
	import_btn.pressed.connect(_on_button_pressed)
	export_enum_btn.pressed.connect(_on_export_enum_btn_pressed)
	convert_enum_to_excel_btn.pressed.connect(_on_convert_enum_to_excel_btn_pressed)
	convert_enum_target_file_regex_edit.text_changed.connect(_on_regex_text_changed)
	convert_enum_target_file_regex_edit.text = convert_enum_target_file_regex
	
func _exit_tree() -> void:
	import_btn.pressed.disconnect(_on_button_pressed)
	export_enum_btn.pressed.disconnect(_on_export_enum_btn_pressed)
	convert_enum_to_excel_btn.pressed.disconnect(_on_convert_enum_to_excel_btn_pressed)
	convert_enum_target_file_regex_edit.text_changed.disconnect(_on_regex_text_changed)

func _on_button_pressed() -> void:
	print("============================== MasterDataConverter run start ==============================")
	var output = []
	var project_path = ProjectSettings.globalize_path("res://")
	var input_path = ProjectSettings.globalize_path(resource_input_path)
	var output_path = ProjectSettings.globalize_path(resource_output_path)
	var batch_path = project_path + "addons/excel_importer/batch/export_data.bat"
	print("execute batch:" + batch_path + "\n")
	#print("input_path:" + str(input_path))
	#print("output_path:" + str(output_path))
	var exit_code = OS.execute(batch_path, [input_path, output_path], output)
	print("result:\n" + str(output).replace("\\r\\n","\n").replace("\\r","\n"))
	print("============================== MasterDataConverter run end ==============================")
	EditorInterface.get_resource_filesystem().scan()
	
func _on_export_enum_btn_pressed() -> void:
	print("============================== ExportEnumJson run start ==============================")
	var exporter = ExportEnumJson.new()
	exporter.export(enum_json_output_path)
	print("============================== ExportEnumJson run end ==============================")
	EditorInterface.get_resource_filesystem().scan()

func _on_convert_enum_to_excel_btn_pressed() -> void:
	print("============================== ConvertEnumToExcel run start ==============================")
	var output = []
	var project_path = ProjectSettings.globalize_path("res://")
	var input_path = ProjectSettings.globalize_path(resource_input_path)
	var import_enum_json_path = ProjectSettings.globalize_path(enum_json_output_path)
	var batch_path = project_path + "addons/excel_importer/convert_enum_to_excel/convert_enum_to_excel.bat"
	print("execute batch:" + batch_path + "\n")
	#print("input_path:" + str(input_path))
	#print("output_path:" + str(output_path))
	convert_enum_target_file_regex = convert_enum_target_file_regex_edit.text
	var regex = r"%s" % convert_enum_target_file_regex if !convert_enum_target_file_regex.is_empty() else ".*"
	var exit_code = OS.execute(batch_path, [input_path, import_enum_json_path, regex], output, true)
	print("result:\n" + str(output).replace("\\r\\n","\n").replace("\\r","\n"))
	print("============================== ConvertEnumToExcel run end ==============================")
	EditorInterface.get_resource_filesystem().scan()

func _on_regex_text_changed(txt:String):
	convert_enum_target_file_regex = txt
