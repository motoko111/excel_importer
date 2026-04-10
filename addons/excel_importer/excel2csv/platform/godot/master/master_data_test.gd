extends Node2D

func _ready() -> void:
	DataAsset.load_all()
	
	var data = DataAsset.get_data("BGMData")
	var fields = data.get_fields()
	var records = data.get_records()
	print(str(fields))
	print(str(records))

func _process(delta: float) -> void:
	pass
