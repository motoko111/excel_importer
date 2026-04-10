import json
import os
import sys
import re
from openpyxl import load_workbook
from openpyxl.worksheet.datavalidation import DataValidation

INPUT_DIR = "input"
INPUT_ENUM_FILE_PATH = "enum/enum_list.json"
TARGET_FILE_REGEX = ".*"

if len(sys.argv) >= 2 and len(sys.argv[1]) > 0:
    INPUT_DIR = sys.argv[1]
    print("inputディレクトリを設定:" + INPUT_DIR)
if len(sys.argv) >= 3 and len(sys.argv[2]) > 0:
    INPUT_ENUM_FILE_PATH = sys.argv[2]
    print("読み込むjsonファイルパスを設定:" + INPUT_ENUM_FILE_PATH)
if len(sys.argv) >= 4 and len(sys.argv[3]) > 0:
    TARGET_FILE_REGEX = sys.argv[3]
    print("対象となるファイル正規表現を設定:" + TARGET_FILE_REGEX)


def apply_enum_list_to_excel(
    excel_path: str,
    enum_json_path: str,
    target_sheet: str = "Sheet1",
    header_row: int = 1,     # enumキーを探す行
    start_row: int = 2       # リスト設定を始める行
):
    """
    Godotで出力したenum定義JSONをもとに、
    Excel内でキー名と一致する列を検索し、
    指定行以降のセルをリスト選択に設定する。

    Args:
        excel_path (str): 編集対象のExcelファイル
        enum_json_path (str): Godotで生成したenums.json
        target_sheet (str): 対象シート名
        header_row (int): enumキーを探す行（例: 1）
        start_row (int): リスト設定を開始する行（例: 2）
    """
    #
    if not(is_target_file_path(excel_path)):
        print(f"対象ファイルの正規表現に一致しないため処理対象から除外します。:{excel_path}")
        return False
    # 
    if is_file_locked(excel_path):
         print(f"エラー!!!:{excel_path}のファイルが開かれています。")
         return False

    # JSON読み込み
    with open(enum_json_path, "r", encoding="utf-8") as f:
        enum_map: dict[str, list[str]] = json.load(f)

    # Excel読み込み
    wb = load_workbook(excel_path)
    if target_sheet not in wb.sheetnames:
        print(f"エラー!!!:指定されたシート '{target_sheet}' が存在しません。")
        return False
    ws = wb[target_sheet]

    updated = 0
    max_col = ws.max_column
    max_row = ws.max_row

    # キー探索行の全セルをチェック
    for col in range(1, max_col + 1):
        key = ws.cell(row=header_row, column=col).value
        if not key:
            continue

        key = str(key).strip()
        if key in enum_map:
            values = enum_map[key]
            if not values:
                continue

            csv = ",".join(values)
            if len(csv) > 255:
                print(f"エラー!!!:{key} のリストが長すぎます。")
                return False
                #csv = ",".join(values[:10])
                
            # リスト適用範囲を設定
            start = ws.cell(row=start_row, column=col).coordinate
            end = ws.cell(row=max_row, column=col).coordinate

            # 削除したい範囲を含む入力規則だけを除外
            new_validations = []
            for dv in ws.data_validations.dataValidation:
                # この範囲を削除したい場合（例: A1:A10）
                if f"{start}:{end}" in dv.sqref:
                    continue  # 削除
                new_validations.append(dv)

            # フィルタリング後の入力規則を再設定
            ws.data_validations.dataValidation = new_validations

            # 指定行以下の全セルにDataValidationを設定
            dv = DataValidation(type="list", formula1=f'"{csv}"', allow_blank=True)
            ws.add_data_validation(dv)

            dv.add(f"{start}:{end}")

            print(f"{key} -> {start}:{end} にリスト設定: {values}")
            updated += 1

    if updated > 0:
        try:
            wb.save(excel_path)
        except ValueError as e:
            print(f"エラー!!!:{excel_path}の保存時にエラーが発生しました。ファイルが開かれている場合は閉じてください。\n: {e}")
            return False
        print(f"完了: {excel_path} に {updated} 列のリスト選択を設定しました。")
    return True

def is_file_locked(filepath: str) -> bool:
    """ファイルが他のプロセス（Excelなど）で開かれているか確認"""
    if not os.path.exists(filepath):
        return False

    try:
        # 'a' モードで開いてすぐ閉じる
        with open(filepath, 'a'):
            pass
        return False
    except PermissionError:
        return True
    
def is_target_file_path(filepath: str) -> bool:
    """ 対象ファイル名が条件に一致しているかチェック """
    return re.match(TARGET_FILE_REGEX, os.path.basename(filepath))

def apply_enum_list_to_excel_dir(dir_path, enum_json_path):
    files = get_input_files(dir_path)
    for file in files:
        filename = os.path.splitext(os.path.basename(file))[0]
        print("================== " + filename + " の処理を開始 ==================")
        apply_enum_list_to_excel(
        excel_path=file,
        enum_json_path=enum_json_path,
        target_sheet=filename,
        header_row=3,   # header_row行目でキーを検索
        start_row=5     # start_row行目以降にリスト設定
        )
        print("================== " + filename + " の処理を終了 ==================")

def get_input_files(dir_path):
    '''
    input配下のファイルを全て取得
    '''
    files = os.listdir(dir_path)
    files_file = [f for f in files if os.path.isfile(os.path.join(dir_path, f))]
    ret = []
    for f in files_file:
        if "~" in f:
            continue
        if not(".xlsx" in f) :
            continue
        ret.append(dir_path + "/" + f)
    return ret

def main():
    apply_enum_list_to_excel_dir(INPUT_DIR, INPUT_ENUM_FILE_PATH)

main()

