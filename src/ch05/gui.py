from tkinter import Canvas, Tk

import numpy as np
from PIL import Image, ImageTk

import pyximport

pyximport.install(language_level=3, setup_args={"include_dirs": np.get_include()})

SIZE_Y = 100
SIZE_X = 200

WIN_X = 1000
WIN_Y = 1000
CANVAS_X = 500
CANVAS_Y = 500
