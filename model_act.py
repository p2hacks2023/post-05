# -*- coding: utf-8 -*-

# ライブラリ
import tensorflow as tf
from PIL import Image



# 生成する画像の枚数の指定
img_num = 1000


# モデルのpathを設定
model_path = r"C:\Users\Hajim\.spyder-py3\p2hacks2023\git\save_model"

# モデルの読み込み
img_model = tf.saved_model.load(model_path)

# 画像を出力
images = img_model.generator(tf.random.normal((img_num, 100)))



# =============================================================================
# 画像を一枚ずつ.pngファイルに保存
# =============================================================================

for i in range(img_num):
    file_path = r"C:\Users\Hajim\.spyder-py3\p2hacks2023\git\complete_image"
    file_path = file_path + r"\image_" + str(i + 1) + ".png"
    
    # 画像を保存
    tf.keras.preprocessing.image.save_img(file_path, images[i] * 0.5 + 0.5)

print("~~~image saved~~~")

    