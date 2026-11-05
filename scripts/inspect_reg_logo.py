from PIL import Image
import numpy as np

img = Image.open('figma_designs/Untitled/DAFTAR AKUN (SEBELUM INPUT, SANDI TUTUP).png').convert('RGB')
arr = np.array(img)

# Top left has the logo: let's crop (15, 45, 65, 95)
crop_reg_logo = arr[45:95, 15:65]
# Find background color (at 0,0)
bg_color = crop_reg_logo[0, 0]
print("Background color in DAFTAR AKUN:", bg_color)

# Let's save the crop
Image.fromarray(crop_reg_logo).save('assets/images/logo_daftar.png')
print("Saved logo_daftar.png")
