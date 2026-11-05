from PIL import Image
import numpy as np

img = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-1.png').convert('RGBA')
arr = np.array(img)

# Center is around (220, 478)
# Let's crop a box around center
crop_logo = img.crop((160, 400, 290, 520))
crop_logo.save('assets/images/logo_splash_raw.png')

print("Logo splash cropped")
