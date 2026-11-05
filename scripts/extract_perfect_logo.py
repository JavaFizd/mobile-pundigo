from PIL import Image
import numpy as np

img1 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-1.png').convert('RGB')
img2 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-2.png').convert('RGB')

arr1 = np.array(img1, dtype=np.float32)
arr2 = np.array(img2, dtype=np.float32)

# Difference
diff = np.abs(arr1 - arr2)
diff_sum = np.sum(diff, axis=2)

# Where diff_sum > 3, it's the logo!
mask = diff_sum > 2.0

# Find bounding box
ys, xs = np.where(mask)
ymin, ymax = ys.min(), ys.max()
xmin, xmax = xs.min(), xs.max()

print(f"Bounding box: y=[{ymin}, {ymax}], x=[{xmin}, {xmax}]")

# Let's add 2px margin
ymin_m = max(0, ymin - 2)
ymax_m = min(arr1.shape[0], ymax + 3)
xmin_m = max(0, xmin - 2)
xmax_m = min(arr1.shape[1], xmax + 3)

# For each pixel in crop:
crop1 = arr1[ymin_m:ymax_m, xmin_m:xmax_m]
crop2 = arr2[ymin_m:ymax_m, xmin_m:xmax_m]
crop_diff = diff_sum[ymin_m:ymax_m, xmin_m:xmax_m]

# Alpha estimation:
# In areas where diff is high, alpha is 1.0. Near edges, alpha is proportional to diff
alpha = np.clip(crop_diff / 30.0, 0.0, 1.0)
# Let's sharpen alpha slightly for clean edges
alpha = np.where(crop_diff > 15, 1.0, crop_diff / 15.0)

# The RGB can just be crop1 (the rendered logo)
result = np.zeros((crop1.shape[0], crop1.shape[1], 4), dtype=np.uint8)
result[:, :, :3] = np.clip(crop1, 0, 255).astype(np.uint8)
result[:, :, 3] = (alpha * 255).astype(np.uint8)

res_img = Image.fromarray(result, 'RGBA')
res_img.save('assets/images/logo_pg_clean.png')
print("Saved perfect logo_pg_clean.png:", res_img.size)
