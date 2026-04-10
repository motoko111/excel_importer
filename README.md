# excel_importer
 - GodotでExcelからデータをインポートするアドオン
 - WindowsでPython3の環境が必要.
 - Godot4.6で動作確認.

## 事前準備
PythonをWindowsバッチから起動しているので以下環境構築が必要になります.

1. Python3のインストール
2. openpyxlのインストール
```
# コマンドプロンプトで以下実行
pip install openpyxl
```

## 使い方
1. addons/excel_importer をコピーしてaddons配下に配置
2. プロジェクト > プラグイン からプラグインを有効化 ※ExcelImporterというドックが追加される
3. プロジェクト配下に以下フォルダを作成 ※プロジェクト設定で変更可能
```
resource
resource/enum
resource/input
resource/output
```
4. Excelファイルを作成
resource/inputにあるエクセルファイルを参照
	- 拡張子は.xlsxのみ対応
	- シートにデータ名を入力. ※シート単位でデータテーブルを出力(シート名がデータ名 {データ名}Manager or DataAsset.get_data("{データ名}")で呼び出す)
	- 1行目、1列目に#と入力するとその行列はコメントアウト扱いになる
	- 1行目 フィールド名 実際にGDScriptで使用する際の名前
	- 2行目 フィールドの型 id,name,string,int,float,double,bool,enumの型名のいずれか
 		* id:int型
 		* name:StringName型
 		* string:String型
 		* int:int型
 		* float:float型
 		* double:double型
 		* bool:bool型
 		* enum: class名.enum名 のように入力して値にenumの値を設定するとそのenumの値をデータに設定できる
	- 3行目 情報 フィールドの説明 空欄でもいい
	- 4行目以降に各レコードのデータを入力
	- 特別なフィールド名
 		* id: データ番号 使用しない場合は重複してもいい データを取得するときに使う 必須
 		* name: データ名 重複しないように データを取得するときに使う 必須
 		* group_id: レコードのグループID、string or name,レコードをまとめて取得したいとき等に使う 不要なら列自体消していい
	- 翻訳データをExcelで登録する場合はシート名を xxxx.csvにするとcsvファイルとしてインポートされる (※resource/input/TextData.xlsxを参照)

5. Excelファイルのインポート
	1. 追加されたExcelImporterという名前のドックを開く
	2. Import from Excel ボタンを押下
	3. 設定した出力フォルダ(デフォルト resource/output)配下にgdscriptのファイルができる
	
6. EnumをExcelのドロップダウンリストに登録する
	1. 追加されたExcelImporterという名前のドックを開く
	2. 「Export Enum to Json」 ボタンを押下
	3. gdscript上で書かれたenum定義が resource/enum配下にjsonで出力される
	4. ドロップダウンリストを登録(更新)したいExcelのファイル名の正規表現を「convert enum to excel > target file regex」に入力 (".*"なら全ファイル "Test.*"なら Test〇〇というファイルを対象)
	5. 対象のExcelファイルを閉じる
	6. 「Convert Enum To Excel Dropdown」 ボタンを押下
	7. Excel にドロップダウンリストが登録されている
	※ ドロップダウンリストには文字数制限があるようなので失敗するとExcelファイルが壊れる場合があります。使用する場合は注意。

7. スクリプト上で登録したデータを使用する
```gdscript
# 全レコードの取得
# データを読み込むのはget_instance()かget_dataを最初に呼んだタイミング
var records = TestDataManager.get_instance().get_records()
print(JSON.stringify(records))
var records = DataAsset.get_data("TestData").get_records()
print(JSON.stringify(records))
```

```gdscript
# 全レコードの取得
var records = TestDataManager.get_instance().get_records()
var records = DataAsset.get_data("TestData").get_records()
```

```gdscript
# 指定グループIDのレコードの取得
var records = TestDataManager.get_instance().find_by_group_id(&"GROUP_1")
```

```gdscript
# idでレコードを取得
var record = TestDataManager.get_instance().find_by_id(3)
```

```gdscript
# nameでレコードを取得
var record = TestDataManager.get_instance().find_by_name(&"TEST_4")
```

```gdscript
# 好きなフィールドのグループを作成して同じ値のデータを取得する
var records = TestDataManager.get_instance().find_by_custom_field(&"val_enum", ETest.TestType.NONE)
```

```gdscript
# Excelからインポートせずに DataAssetに登録しない汎用的なデータアクセスを作成することも可能
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
```

8. 出力パス等の設定を変更したい場合
	- プロジェクト設定 > 一般 > Lib > Master から入出力フォルダパス等の設定が可能
	- スクリプト上から変更する場合
```gdscript
# Excelファイルを置く場所
ProjectSettings.set_setting("lib/master/resource_input_path", "res://resource/input")
# GDScriptファイルが出力される場所
ProjectSettings.set_setting("lib/master/resource_output_path", "res://resource/output")
# マスターデータのパスを変更(ExcelからインポートしたGDScriptのファイルがある場所. 複数設定可能. 基本lib/master/resource_output_pathと同じにしておけばいい.)
DataAsset.s_master_datapaths = ["res://resource/output"]
```
