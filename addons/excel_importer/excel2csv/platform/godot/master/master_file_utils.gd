class_name MasterFileUtils

static func get_files(path:String) -> Array[String]:
	var files:Array[String] = []
	_get_files(path, files, path.ends_with("res://"))
	return files
			
static func _get_files(path:String, ref_files:Array[String], is_top:bool = false):
	if path.ends_with("/") and !is_top:
		path = path.substr(0, path.length()-1)
	var dir_or_file_list = ResourceLoader.list_directory(path)
	var add_slash = "/"
	if is_top:
		add_slash = ""
	for dir_or_file in dir_or_file_list:
		if dir_or_file.ends_with("/"):
			_get_files(path + add_slash + dir_or_file, ref_files)
		else:
			ref_files.push_back(path + add_slash + dir_or_file)
			
static func exists_file(path:String) -> bool:
	return ResourceLoader.exists(path)

static func write(path:String, data:String) -> bool:
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		DirAccess.make_dir_absolute(path.get_base_dir())
	var file:FileAccess = null
	file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		print("[MasterFileUtils::write] open error : " + str(FileAccess.get_open_error()))
		return false
	file.store_string(data)
	file.close()
	print("[MasterFileUtils::write] path:" + str(path) + " save" + " success.")
	return true

static func read(path:String) -> String:
	if !FileAccess.file_exists(path):
		print("[MasterFileUtils::read] load_data failed... not found " + str(path))
		return ""
	var file:FileAccess = null
	file = FileAccess.open(path,FileAccess.READ)
	if !file:
		print("[MasterFileUtils::read] open error : " + str(FileAccess.get_open_error()))
		return ""
	var data = file.get_as_text()
	print("[MasterFileUtils::read] path:" + str(path) + " load" + " success.")
	return data

static func delete(path:String) -> bool:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("[MasterFileUtils::delete] path:" + str(path) + " delete success.")
		return true
	return false
