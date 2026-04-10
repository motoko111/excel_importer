# tool
class_name ExportEnumJson
var output_path := "res://enums.json"

func export(_output_path:String):
	output_path = _output_path
	_run()

func _run():
	var result := {}
	var dir := DirAccess.open("res://")
	_scan_dir(dir, result)

	var json_str := JSON.stringify(result, "\t")
	_write(output_path, json_str)
	print("✅ Enum definitions exported to:", output_path)

func _write(path:String, data:String) -> bool:
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		DirAccess.make_dir_absolute(path.get_base_dir())
	var file:FileAccess = null
	file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		print("[ExportEnumJson::write] open error : " + str(FileAccess.get_open_error()))
		return false
	file.store_string(data)
	file.close()
	print("[ExportEnumJson::write] path:" + str(path) + " save" + " success.")
	return true


func _scan_dir(dir: DirAccess, result: Dictionary):
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir() and not file_name.begins_with("."):
			_scan_dir(DirAccess.open(dir.get_current_dir() + "/" + file_name), result)
		elif file_name.ends_with(".gd"):
			var path = dir.get_current_dir() + "/" + file_name
			var text := FileAccess.get_file_as_string(path)
			
			# コメントを除去
			text = _remove_comments(text)
			
			var cls_name := _extract_class_name(text)
			if cls_name != "":
				var enums := _extract_enums(text)
				for enum_name in enums.keys():
					var key := "%s.%s" % [cls_name, enum_name]
					result[key] = enums[enum_name]
		file_name = dir.get_next()

# class_nameを抽出
func _extract_class_name(text: String) -> String:
	var regex := RegEx.new()
	regex.compile(r"class_name\s+(\w+)")
	var m := regex.search(text)
	if m:
		return m.get_string(1)
	return ""

# コメントを削除（単一行 / ブロックコメント対応）
func _remove_comments(text: String) -> String:
	# 1. """ ～ """ のブロックコメントを除去
	var regex_block1 := RegEx.new()
	regex_block1.compile(r'""".*?"""')
	text = regex_block1.sub(text, "")

	# 2. ''' ～ ''' のブロックコメントを除去
	var regex_block2 := RegEx.new()
	regex_block2.compile(r"'''.*?'''")
	text = regex_block2.sub(text, "")

	# 3. # 以降を除去（単一行コメント）
	var regex_line := RegEx.create_from_string(r"#.*")
	text = regex_line.sub(text, "", true)  # 全行置換
	return text

# enum定義を抽出（値順に並べ替えて名前だけ返す）
func _extract_enums(text: String) -> Dictionary:
	var result := {}
	var regex := RegEx.new()
	regex.compile(r"enum\s+(\w+)\s*\{([^}]+)\}")
	for m in regex.search_all(text):
		var name := m.get_string(1)
		var body := m.get_string(2)
		var entries := {}
		var parts := body.split(",", false)
		var value := 0
		for part in parts:
			part = part.strip_edges()
			if part == "":
				continue
			var key_val = part.split("=", false)
			if key_val.size() == 2:
				var val_str := key_val[1].strip_edges()
				var val := int(val_str) if val_str.is_valid_int() else value
				entries[key_val[0].strip_edges()] = val
				value = val + 1
			else:
				entries[key_val[0].strip_edges()] = value
				value += 1
		# 値順にソートしてキー名だけ抽出
		var sorted_keys := entries.keys()
		sorted_keys.sort_custom(func(a, b): return entries[a] < entries[b])
		result[name] = sorted_keys
	return result
