# -*- coding: utf-8 -*-
# ライブラリ
import matplotlib.pyplot as plt
import seaborn as sns
import tensorflow as tf
from tensorflow.keras.models import Sequential, Model
from tensorflow.keras.layers import Input, Conv2DTranspose, Conv2D, Dense, Reshape, Flatten, BatchNormalization, LeakyReLU, RandomCrop, ReLU
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import Callback


# =============================================================================
# GPUのメモリを設定
# =============================================================================

# GPUのリストを取得
physical_devices = tf.config.list_physical_devices('GPU')

# GPUメモリを動的に設定
try:
  tf.config.experimental.set_memory_growth(physical_devices[0], True)
except:
  pass

# Seabornの設定
sns.set() # 無くても大丈夫だけど、あった方が見た目が良くなるらしい


# =============================================================================
# 画像の前処理
# =============================================================================

# 画像の前処理
def scaling(image):
    return image / 127.5 - 1


# =============================================================================
# DCGANの定義
# =============================================================================

class GAN(Model):
    def __init__(self):
        super(GAN, self).__init__()
        
        # Generator（生成器）の設定
        self.generator = tf.keras.Sequential([
            # 100次元のランダムノイズを入力
            Input((100,)),
            # 全結合層
            Dense(4*4*1024),
            Reshape((4, 4, 1024)),
            
            # 逆畳み込み層（8 × 8 × 512）
            Conv2DTranspose(512, 4, strides=2, padding="same"),
            BatchNormalization(),
            LeakyReLU(0.2),
            
            # 逆畳み込み層（16 × 16 × 256）
            Conv2DTranspose(256, 4, strides=2, padding="same"),
            BatchNormalization(),
            LeakyReLU(0.2),
            
            # 逆畳み込み層(32 × 32 × 128)
            Conv2DTranspose(128, 4, strides=2, padding="same"),
            BatchNormalization(),
            LeakyReLU(0.2),
            
            # 逆畳み込み層(64 × 64 × 3)
            Conv2DTranspose(3, 4, strides=2, padding="same", activation="tanh")
        ], name="generator")
        
        
        # Discriminator(識別機)の設定
        self.discriminator = tf.keras.Sequential([
            # 入力
            Input((64, 64, 3)),
            
            # 畳み込み層（32 × 32 × 64）
            Conv2D(64, 4, strides=2, padding="same"),
            LeakyReLU(0.2),
            
            # 畳み込み層（16 × 16 × 128）
            Conv2D(128, 4, strides=2, padding="same"),
            BatchNormalization(),
            LeakyReLU(0.2),
            
            # 畳み込み層（8 × 8 × 256）
            Conv2D(256, 4, strides=2, padding="same"),
            BatchNormalization(),
            LeakyReLU(0.2),
            
            # 畳み込み層（4 × 4 × 1）
            Conv2D(1, 4, strides=2, padding="same"),

            Flatten(),
            Dense(1, activation="sigmoid")
        ])
    
    
    # 最適化アルゴリズム、損失関数の設定
    def compile(self, d_optimizer, g_optimizer, loss_fn):
        super(GAN, self).compile()
        self.d_optimizer = d_optimizer
        self.g_optimizer = g_optimizer
        self.loss_fn = loss_fn

        self.d_loss_tracker = tf.keras.metrics.Mean(name="d_loss")
        self.g_loss_tracker = tf.keras.metrics.Mean(name="g_loss")
    
    
    # 損失のトラッキング
    @property
    def metrics(self):
        return [self.d_loss_tracker, self.g_loss_tracker]
    
    
    # 勾配、損失などの計算
    def train_step(self, real_images):
        batch_size = tf.shape(real_images)[0]

        random_latent_vectors = tf.random.normal(shape=(batch_size, 100))
        real_labels = tf.ones((batch_size, 1)) + 0.5 * tf.random.uniform((batch_size, 1), minval=-1, maxval=1)
        fake_labels = tf.zeros((batch_size, 1)) + 0.25 * tf.random.uniform((batch_size, 1), )
        flipped_fake_labels = tf.ones((batch_size, 1))

        with tf.GradientTape() as d_tape, tf.GradientTape() as g_tape:
            real_preds = self.discriminator(real_images)
            fake_images = self.generator(random_latent_vectors)
            fake_preds = self.discriminator(fake_images)

            d_loss_real = self.loss_fn(real_labels, real_preds)
            d_loss_fake = self.loss_fn(fake_labels, fake_preds)
            d_loss = d_loss_real + d_loss_fake

            g_loss = self.loss_fn(flipped_fake_labels, fake_preds)
        
        d_grads = d_tape.gradient(d_loss, self.discriminator.trainable_weights)
        self.d_optimizer.apply_gradients(zip(d_grads, self.discriminator.trainable_weights))
        g_grads = g_tape.gradient(g_loss, self.generator.trainable_weights)
        self.g_optimizer.apply_gradients(zip(g_grads, self.generator.trainable_weights))

        self.d_loss_tracker.update_state(d_loss)
        self.g_loss_tracker.update_state(g_loss)
        return {"d_loss": self.d_loss_tracker.result(), "g_loss": self.g_loss_tracker.result()}



# =============================================================================
# データセットの指定
# =============================================================================
dataset = tf.keras.preprocessing.image_dataset_from_directory(
    directory=r"C:\Users\Hajim\.spyder-py3\p2hacks2023\Python\test_data",
    label_mode=None,
    image_size=(64, 64),
    shuffle=False,
)

dataset = dataset.map(scaling).unbatch().cache().shuffle(10000).batch(128)



# =============================================================================
# イメージのプロット
# =============================================================================
# イメージをプロット
plt.figure(figsize=(10, 10))
for images in dataset.take(1):
    for i in range(16):
        ax = plt.subplot(4, 4, i+1)
        ax.imshow(images[i] * 0.5 + 0.5)
        plt.axis("off")
plt.show()



# =============================================================================
# モデルを作成
# =============================================================================

# モデルのインスタンス化
model = GAN() 
# Generatorのsummaryの表示
model.generator.summary()
# Discriminatorのsummaryの表示
model.discriminator.summary()

# モデルの作成
model.generator(tf.random.normal((32, 100))).shape, model.discriminator(tf.random.normal((32, 64, 64, 3))).shape




# =============================================================================
# DCGANモデルの学習進捗を可視化するためのクラス
# =============================================================================
class GANMonitor(Callback):
    def __init__(self, num_img=16, latent_dim=100):
        self.num_img = num_img
        self.latent_dim = latent_dim
        # 固定のランダムノイズベクトルを生成
        self.random_latent_vectors = tf.random.normal(shape=(self.num_img, self.latent_dim))
    
    # エポック終了時に呼ばれるメソッド
    def on_epoch_end(self, epoch, logs=None):
        # Generatorにランダムノイズを入力
        generated_images = self.model.generator(self.random_latent_vectors)
        
        # 生成画像を4 × 4でプロットして表示
        plt.figure(figsize=(10, 10))
        for i in range(self.num_img):
            ax = plt.subplot(4, 4, i+1)
            ax.imshow(generated_images[i] * 0.5 + 0.5)
            plt.axis("off")
        
        # 保存先のパスを指定
        epoch_path = "test" + str(epoch + 1).zfill(5)
        plt.savefig(r"C:\Python\test_data\finish.png")
        plt.close("all")

model.compile(
    d_optimizer=Adam(0.0002, 0.5),
    g_optimizer=Adam(0.0002, 0.5),
    loss_fn=tf.keras.losses.BinaryCrossentropy(),
)

history = model.fit(
    dataset,
    epochs=1650,
    callbacks=[GANMonitor(num_img=16, latent_dim=100)]
)



# 生成し、プロットする

images = model.generator(tf.random.normal((16, 100)))

plt.figure(figsize=(10, 10))
for i in range(16):
    ax = plt.subplot(4, 4, i+1)
    ax.imshow(images[i] * 0.5 + 0.5)
    plt.axis("off")
plt.show()


# モデルの保存
tf.saved_model.save(model, r"C:\Users\Hajim\JN_test\save_model")

