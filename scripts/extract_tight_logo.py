from PIL import Image
import numpy as np

img1 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-1.png').convert('RGB')
img2 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-2.png').convert('RGB')

arr1 = np.array(img1, dtype=np.float32)
arr2 = np.array(img2, dtype=np.float32)

diff = np.abs(arr1 - arr2)
diff_sum = np.sum(diff, axis=2)

# Where diff is high (the solid logo)
mask_logo = diff_sum > 35.0
ys, xs = np.where(mask_logo)
ymin, ymax = ys.min(), ys.max()
xmin, xmax = xs.min(), xs.max()

print(f"Tight logo bounding box: y=[{ymin}, {ymax}], x=[{xmin}, {xmax}]")

# Add 2px safety padding
ymin = max(0, ymin - 2)
ymax = min(arr1.shape[0], ymax + 3)
xmin = max(0, xmin - 2)
xmax = min(arr1.shape[1], xmax + 3)

crop1 = arr1[ymin:ymax, xmin:xmax]
crop2 = arr2[ymin:ymax, xmin:xmax]
c_diff = diff_sum[ymin:ymax, xmin:xmax]

# To get clean transparency around edges:
# Background color in this region is very close to crop2
# The alpha can be computed based on difference from background:
# when c_diff < 8 -> alpha 0
# when c_diff > 35 -> alpha 1
# smoothly interpolate between 8 and 35
alpha = np.clip((c_diff - 8.0) / (35.0 - 8.0), 0.0, 1.0)

# Un-premultiply / recover foreground color near anti-aliased edge:
# C_observed = alpha * C_fg + (1 - alpha) * C_bg
# => C_fg = (C_observed - (1 - alpha) * C_bg) / alpha
fg = np.zeros_like(crop1)
valid = alpha > 0.05
for c in range(3):
    fg[valid, c] = np.clip(
        (crop1[valid, c] - (1.0 - alpha[valid]) * crop2[valid, c]) / alpha[valid],
        0.0, 255.0
    )

rgba = np.zeros((crop1.shape[0], crop1.shape[1], 4), dtype=np.uint8)
rgba[:, :, :3] = fg.astype(np.uint8)
rgba[:, :, 3] = (alpha * 255).astype(np.uint8)

res_img = Image.fromarray(rgba, 'RGBA')
res_img.save('assets/images/logo_pg_clean.png')

# Also save a 2x and 3x upscale or high quality version
print("Saved tight logo_pg_clean.png:", res_img.size)
