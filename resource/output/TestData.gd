
class_name TestDataManager
extends MasterDataManager
static var s_instance = null
static func get_instance() -> TestDataManager:
	if !s_instance:
		s_instance = TestDataManager.new()
	return s_instance
func _init():
	data_name = "TestData"
	fields = {
		id = "ID",
		group_id = "グループID",
		name = "名前",
		display_name = "表示名",
		val_enum = "テストタイプ",
		val_int = "テストint",
		val_float = "テストfloat",
		val_double = "テストdouble",
		val_bool = "テストbool",
		val_name = "テストname",
	}
	records = [
		{
			id = 1,# ID 
			group_id = &"GROUP_1",# グループID 
			name = &"TEST_1",# 名前 
			display_name = "TXT_TEST_1",# 表示名 
			val_enum = ETest.TestType.TYPE_1,# テストタイプ 
			val_int = 1,# テストint 
			val_float = 0.1,# テストfloat 
			val_double = 0.1,# テストdouble 
			val_bool = false,# テストbool 
			val_name = &"NAME_1",# テストname 
		}, 
		{
			id = 2,# ID 
			group_id = &"GROUP_1",# グループID 
			name = &"TEST_2",# 名前 
			display_name = "TXT_TEST_2",# 表示名 
			val_enum = ETest.TestType.TYPE_2,# テストタイプ 
			val_int = 2,# テストint 
			val_float = 0.2,# テストfloat 
			val_double = 0.2,# テストdouble 
			val_bool = true,# テストbool 
			val_name = &"NAME_2",# テストname 
		}, 
		{
			id = 3,# ID 
			group_id = &"GROUP_1",# グループID 
			name = &"TEST_3",# 名前 
			display_name = "TXT_TEST_3",# 表示名 
			val_enum = ETest.TestType.TYPE_3,# テストタイプ 
			val_int = 3,# テストint 
			val_float = 0.3,# テストfloat 
			val_double = 0.3,# テストdouble 
			val_bool = false,# テストbool 
			val_name = &"NAME_3",# テストname 
		}, 
		{
			id = 4,# ID 
			group_id = &"GROUP_2",# グループID 
			name = &"TEST_4",# 名前 
			display_name = "TXT_TEST_4",# 表示名 
			val_enum = ETest.TestType.NONE,# テストタイプ 
			val_int = 4,# テストint 
			val_float = 0.4,# テストfloat 
			val_double = 0.4,# テストdouble 
			val_bool = true,# テストbool 
			val_name = &"NAME_4",# テストname 
		}, 
		{
			id = 5,# ID 
			group_id = &"GROUP_3",# グループID 
			name = &"TEST_5",# 名前 
			display_name = "TXT_TEST_5",# 表示名 
			val_enum = ETest.TestType.NONE,# テストタイプ 
			val_int = 5,# テストint 
			val_float = 0.5,# テストfloat 
			val_double = 0.5,# テストdouble 
			val_bool = false,# テストbool 
			val_name = &"NAME_5",# テストname 
		}, 
	]
	super._init()
