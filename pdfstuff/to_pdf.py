import sys
import os
from fpdf import FPDF

imgdir = sys.argv[1]

images = [f for f in os.listdir(imgdir) if f.endswith('.png')]



pdf = FPDF('L', 'mm', 'A4')

h=1080/1920*297
y = (210 - h) / 2
for f in sorted(images):
    pdf.add_page()
    pdf.image(os.path.join(imgdir, f), x=0, y=y, w=297, h=h)
pdf.output('output.pdf', 'F')

