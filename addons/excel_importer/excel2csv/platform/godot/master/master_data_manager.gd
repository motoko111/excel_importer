class_name MasterDataManager

var name_map = {}
var id_map = {}
var group_id_map = {}
var data_name = ""
var fields = {}
var records = {}
var custom = {}

func _init():
	DataAsset.register(data_name, self)
	var master_data_type:StringName = StringName(data_name)
	for record in records:
		record.master_data_type = master_data_type
		if record.has("name"):
			if name_map.has(record.name):
				printerr("name:[%s]はすでに登録されています. %s" % [record.name, self.get_script().resource_path])
			name_map[record.name] = record
		if record.has("id"):
			id_map[record.id] = record
		if record.has("group_id"):
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

func get_fields():
	return fields

func find_by_id(id):
	if !id_map.has(id):
		assert(false)
		return null
	return id_map[id]

func find_by_name(name):
	if !name_map.has(name):
		assert(false)
		return null
	return name_map[name]
	
func find_by_custom_field(field, val):
	if !custom.has(field):
		create_custom_id_map(field)
		if !custom.has(field):
			return []
	var map = custom[field]
	if map.has(val):
		return map[val]
	return []
	
func create_custom_id_map(field):
	if custom.has(field):
		return
	var dic = {}
	for record in records:
		if record.has(field):
			var val = record.get(field)
			if !dic.has(val):
				dic[val] = []
			dic[val].append(record)
	custom[field] = dic
