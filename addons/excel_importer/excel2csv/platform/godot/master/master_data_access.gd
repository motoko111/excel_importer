class_name MasterDataAccess
## DataAssetに登録しない汎用的なデータアクセスクラス

var name_map = {}
var id_map = {}
var group_id_map = {}
var records = []

func _init():
	update_record_map()
	
func add(record):
	records.push_back(record)
	_register_record(record)
				
func update_record_map():
	name_map.clear()
	id_map.clear()
	group_id_map.clear()
	for record in records:
		_register_record(record)
				
func _register_record(record):
	if record is Dictionary:
		if record.has("name"):
			name_map[record.name] = record
		if record.has("id"):
			id_map[record.id] = record
		if record.has("group_id"):
			if !group_id_map.has(record.group_id):
				group_id_map[record.group_id] = []
			group_id_map[record.group_id].append(record)
	else:
		if record.get("name"):
			name_map[record.name] = record
		if record.get("id"):
			id_map[record.id] = record
		if record.get("group_id"):
			if !group_id_map.has(record.group_id):
				group_id_map[record.group_id] = []
			group_id_map[record.group_id].append(record)

func get_records():
	return records
	
func get_name_map_records():
	return name_map

func get_id_map_records():
	return id_map
	
func get_group_id_map_records():
	return group_id_map
	
func find_by_group_id(groupId):
	if group_id_map.has(groupId):
		return group_id_map[groupId]
	return []

func find_by_id(id):
	if !id_map.has(id):
		return null
	return id_map[id]

func find_by_name(name):
	if !name_map.has(name):
		return null
	return name_map[name]
