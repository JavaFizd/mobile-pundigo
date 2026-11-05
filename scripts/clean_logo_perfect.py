from PIL import Image
import numpy as np

img1 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-1.png').convert('RGB')
arr1 = np.array(img1, dtype=np.float32)

# Precise bounds of the 3D logo in HALAMAN PEMBUKA-1.png:
# y: 401..494, x: 171..287
crop = arr1[400:495, 170:288]

# Background around it has: R: ~230-245, G: ~250, B: ~252
# Inside logo: R is always <= 120
# Let's inspect R channel:
# r <= 100 -> alpha = 1.0
# r >= 225 -> alpha = 0.0
# In between -> linear interpolation
r = crop[:, :, 0]
g = crop[:, :, 1]
b = crop[:, :, 2]

# Let's measure distance to background color (235, 250, 252)
bg_color = np.array([235.0, 250.0, 252.0])
dist_to_bg = np.sqrt(np.sum((crop - bg_color)**2, axis=2))

# Logo pixels have dist_to_bg > 120
# Background has dist_to_bg < 15
alpha = np.clip((dist_to_bg - 18.0) / 75.0, 0.0, 1.0)

# Clean cut for pure background
alpha[dist_to_bg < 15.0] = 0.0

# Also unmix edge colors so there is zero white halo
fg = np.copy(crop)
for c in range(3):
    fg[:, :, c] = np.clip((crop[:, :, c] - (1.0 - alpha) * bg_color[c]) / np.maximum(alpha, 0.01), 0.0, 255.0)

rgba = np.zeros((crop.shape[0], crop.shape[1], 4), dtype=np.uint8)
rgba[:, :, :3] = fg.astype(np.uint8)
rgba[:, :, 3] = (alpha * 255).astype(np.uint8)

res_img = Image.fromarray(rgba, 'RGBA')

# Trim any completely empty outer rows/cols
bbox = res_img.getbbox()
if bbox:
    res_img = res_img.crop(bbox)

res_img.save('assets/images/logo_pg_clean.png')
print("Successfully saved ultra-clean logo_pg_clean.png with size:", res_img.size)
