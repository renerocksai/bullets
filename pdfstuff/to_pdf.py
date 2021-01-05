import sys
import os
from fpdf import FPDF
from PIL import Image
from tqdm import tqdm

def resize(png):
    img = Image.open(png)
    new_width  = 1920
    new_height = 1080
    img = img.resize((new_width, new_height), Image.ANTIALIAS)
    img.save(f'{png}_resized.png') # format may what


imgdir = sys.argv[1]

images = [f for f in os.listdir(imgdir) if f.endswith('.png') and '_resized' not in f]




h=int(297/1920*1080)
w=297
print(f'{w}x{h}')
pdf = FPDF('L', 'mm', (h, w))

for f in tqdm(sorted(images)):
    pdf.add_page()
    png = os.path.join(imgdir, f)
    resize(png)
    pdf.image(f'{png}_resized.png', x=0, y=0, w=297, h=h)
pdf.output('output.pdf', 'F')

