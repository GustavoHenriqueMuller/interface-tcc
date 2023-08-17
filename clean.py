import glob
import os

EXTENSION = "*.vhd.bak"
PATH = "./hdl/**/" + EXTENSION

for filename in glob.iglob(PATH, recursive = True):
    os.remove(filename)