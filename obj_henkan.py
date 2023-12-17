# -*- coding: utf-8 -*-

# ライブラリ
import os
import cv2
# # Dependencies for callable functions.
# from firebase_functions import https_fn, options
# # Dependencies for writing to Realtime Database.
# from firebase_admin import db, initialize_app





def make_obj(ice):
    
    # pathの設定
    # 3Dモデルのまとまったフォルダ
    before_path = r"before_obj"
    after_path = r"after_obj"
    
    # 加工前
    img_path_bar = before_path + r"\ice_bar.png" # 棒の方
    img_path_before = before_path + r"\ice_image.png" # アイスの方
    
    # 3Dモデルについてのファイル
    obj_path = before_path + r"\model.obj"
    mtl_path = before_path + r"\model.mtl"
    
    # モデル名
    material_name = "new_IceCream"
    
    
    # テクスチャをリサイズ
    img_bar = cv2.imread(img_path_bar)
    img_before = cv2.imread(img_path_before)
    width = img_bar.shape[1]
    height = img_bar.shape[0]
    img_resized = cv2.resize(img_before, (width, height))
    # img_resized.save(img_path_before, quality = 90)
    img_add = cv2.addWeighted(img_bar, 0.5, img_resized, 0.5, 0.0)
    
    new_texture_path = after_path + r"\Rainbow_Sherbet_Ice_Cream_Cone.png"
    cv2.imwrite(after_path + r"\Rainbow_Sherbet_Ice_Cream_Cone.png", img_add)
    
    
    # MTLファイルを読み込み
    with open(mtl_path, 'r') as mtl_file:
        mtl_content = mtl_file.readlines()

    # 新しいテクスチャパスに変更
    for i in range(len(mtl_content)):
        line = mtl_content[i]
        if line.startswith('map_Kd') and material_name in line:
            mtl_content[i] = f'map_Kd Rainbow_Sherbet_Ice_Cream_Cone.png\n'

    # 変更を保存
    with open(os.path.join(after_path, 'model.mtl'), 'w') as new_mtl_file:
        new_mtl_file.writelines(mtl_content)

    # OBJファイルを読み込み
    with open(obj_path, 'r') as obj_file:
        obj_content = obj_file.readlines()

    # MTLファイルのパスを変更
    for i in range(len(obj_content)):
        line = obj_content[i]
        if line.startswith('mtllib'):
            obj_content[i] = f'mtllib model.mtl\n'

    # 変更を保存
    with open(os.path.join(after_path, 'model.obj'), 'w') as new_obj_file:
        new_obj_file.writelines(obj_content)
    
    
    return after_path


b = 1
a = make_obj(b)