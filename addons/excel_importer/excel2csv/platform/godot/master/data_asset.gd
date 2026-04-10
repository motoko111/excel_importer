class_name DataAsset

##
## # マスターデータのパスを変更する場合
## DataAsset.s_master_datapaths = ["res://game/master/data"]
## 

static var s_instance = null
static var s_master_datapaths:Array[String]:
	set(v):
		ProjectSettings.set_setting("lib/master/data_paths", v)
	get():
		return ProjectSettings.get_setting("lib/master/data_paths", [
			"res://addons/excel_importer/excel2csv/platform/godot/master/data",
			"res://resource/output"
			])
var master = {}

static func get_instance():
	if s_instance == null:
		s_instance = DataAsset.new()
	return s_instance

static func register(data_name, data):
	get_instance().master[data_name]= data

static func clear():
	get_instance().master = {}
	
static func load_all():
	for dir in s_master_datapaths:
		var files = MasterFileUtils.get_files(dir)
		for file:String in files:
			DataAsset.get_data(file.get_file().replace(".gd",""))
		
static func _create_data_instance(data_name):
	for dir in s_master_datapaths:
		if dir.ends_with("/"):
			dir = dir.substr(0,dir.length()-1)
		var path = dir + "/" + data_name + ".gd"
		if !MasterFileUtils.exists_file(path):
			printerr("[DataAsset::_create_data_instance] not found file [%s]" % [path])
			return
		var class_ref = load(path)
		var data = class_ref.get_instance()
		if data :
			register(data_name, data)
			return

static func get_data(data_name):
	if !get_instance().master.has(data_name):
		_create_data_instance(data_name)
		if get_instance().master.has(data_name):
			return get_instance().master[data_name]
		return null
	return get_instance().master[data_name]

static func get_records(data_name):
	return get_data(data_name).get_records()
	
static func get_name_map_records(data_name):
	return get_data(data_name).get_name_map_records()

static func get_id_map_records(data_name):
	return get_data(data_name).get_id_map_records()

static func get_fields(data_name):
	return get_data(data_name).get_fields()

static func find_by_id(data_name,id):
	return get_data(data_name).find_by_id(id)

static func find_by_name(data_name,name):
	return get_data(data_name).find_by_name(name)
	
static func find_by_group_id(data_name,groupId):
	return get_data(data_name).find_by_group_id(groupId)
	
static func find_by_custom_field(data_name,field,value):
	return get_data(data_name).find_by_custom_field(field,value)

static func get_data_master():
	return get_instance().master
