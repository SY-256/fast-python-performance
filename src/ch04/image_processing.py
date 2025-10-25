import sys

import numpy as np
from PIL import Image

image = Image.open("./manning-logo.png").convert("L")
print("Image size", image.size)
width, heigth = image.size

image_arr = np.array(image)
print("Array shape, array type: ", image_arr.shape, image_arr.dtype)
print("Array size * item size: ", image_arr.nbytes)
print("Array nbytes: ", image_arr.nbytes)
print("sys.getsizeof: ", sys.getsizeof(image_arr))
flipped_from_view = np.flipud(image_arr)  # ビューを作成して画像を上下反転させる
flipped_from_copy = np.flipud(image_arr).copy()  # 画像を反転させ、そのコピーを作成
print(image_arr.strides, flipped_from_view.strides)
image_arr[:, : width // 2] = 0
removed = Image.fromarray(image_arr, "L")
image.save("image.png")
removed.save("removed.png")

flipped_from_view_image = Image.fromarray(flipped_from_view, "L")
flipped_from_view_image.save("flipped_view.png")
flipped_from_view_image = Image.fromarray(flipped_from_copy, "L")
flipped_from_view_image.save("flipped_copy.png")

print(image_arr == flipped_from_view.base)
print(
    np.shares_memory(image_arr, flipped_from_copy),
    np.shares_memory(image_arr, flipped_from_view),
)

print(1)
print(flipped_from_copy.base, flipped_from_view.base)
print(flipped_from_view.base is image_arr)  # 同じオブジェクトか確認
print(flipped_from_view.base == image_arr)  # 両方の配列の値がすべて等しいかを確認

flipped_from_copy = np.flipud(image_arr.copy())
