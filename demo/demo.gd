extends Control

@onready var label:RichTextLabel = $VBoxContainer/RichTextLabel

func _ready() -> void:
	_clear_log()
	_test_get_records()
	_test_find_by_group_id()
	_test_find_by_id()
	_test_find_by_name()
	_test_custom_group_filed()
	_test_text()
	_test_create_custom_data_access()
	
func _test_get_records():
	_add_log("_test_get_records: class")
	var records = TestDataManager.get_instance().get_records()
	_add_log(JSON.stringify(records))
	_add_log("")
	_add_log("_test_get_records: class name")
	records = DataAsset.get_data("TestData").get_records()
	_add_log(JSON.stringify(records))
	_add_log("")
	
func _test_find_by_group_id():
	_add_log("_test_find_by_group_id: GROUP_1")
	var records = TestDataManager.get_instance().find_by_group_id(&"GROUP_1")
	_add_log(JSON.stringify(records))
	_add_log("")
	
func _test_find_by_id():
	var record = TestDataManager.get_instance().find_by_id(3)
	_add_log("_test_find_by_id: 3")
	_add_log(JSON.stringify(record))
	_add_log("")
	
func _test_find_by_name():
	var record = TestDataManager.get_instance().find_by_name(&"TEST_4")
	_add_log("_test_find_by_name: TEST_4")
	_add_log(JSON.stringify(record))
	_add_log("")
	
func _test_custom_group_filed():
	# 好きなフィールドのグループを作成して同じ値のデータを取得する
	_add_log("_test_custom_group_filed: ETest.TestType.NONE")
	var records = TestDataManager.get_instance().find_by_custom_field(&"val_enum", ETest.TestType.NONE)
	_add_log(JSON.stringify(records))
	_add_log("")
	
func _test_text():
	# 翻訳
	# プロジェクト設定 > ローカライズに translationを登録する必要がある
	_add_log("_test_text:")
	var records = TestDataManager.get_instance().get_records()
	TranslationServer.set_locale("jp")
	for record in records:
		_add_log(tr(record.display_name))
	TranslationServer.set_locale("en")
	for record in records:
		_add_log(tr(record.display_name))
	TranslationServer.set_locale("ko")
	for record in records:
		_add_log(tr(record.display_name))
	TranslationServer.set_locale("zh_CN")
	for record in records:
		_add_log(tr(record.display_name))
	TranslationServer.set_locale("zh_TW")
	for record in records:
		_add_log(tr(record.display_name))
	_add_log("")
	
func _test_create_custom_data_access():
	# Excelからインポートせずに スクリプト上でDataAssetに登録しない汎用的なデータアクセスを作成することも可能
	var access = MasterDataAccess.new()
	access.add({
		id = 1,
		name = &"TestName_1",
		val_int = 1000,
		val_str = "test dayo 1"
	})
	access.add({
		id = 2,
		name = &"TestName_2",
		val_int = 2000,
		val_str = "test dayo 2"
	})
	_add_log("_test_create_custom_data_access: get_records")
	var records = access.get_records()
	_add_log(JSON.stringify(records))
	_add_log("")
	_add_log("_test_create_custom_data_access: find_by_id 1")
	var record = access.find_by_id(1)
	_add_log(JSON.stringify(record))
	_add_log("")
	
func _clear_log():
	label.text = ""
	
func _add_log(s:String):
	label.text += s + "\n"
