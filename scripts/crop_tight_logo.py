from PIL import Image
import numpy as np

img1 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-1.png').convert('RGB')
img2 = Image.open('figma_designs/Untitled/HALAMAN PEMBUKA-2.png').convert('RGB')

arr1 = np.array(img1, dtype=np.float32)
arr2 = np.array(img2, dtype=np.float32)

diff = np.abs(arr1 - arr2)
diff_sum = np.sum(diff, axis=2)

# Find where the color is NOT the mint background
# Logo pixels have saturation / darkness significantly different from the background
# Specifically, in the region y in 410..525, x in 155..290:
logo_region = (diff_sum > 60.0)
ys, xs = np.where(logo_region)
ymin, ymax = ys.min(), ys.max()
xmin, xmax = xs.min(), xs.max()

print(f"Precise logo bounding box: y=[{ymin}, {ymax}], x=[{xmin}, {xmax}]")

# Crop tight with 1px margin
pad = 1
ymin = max(0, ymin - pad)
ymax = min(arr1.shape[0], ymax + pad + 1)
xmin = max(0, xmin - pad)
xmax = min(arr1.shape[1], xmax + pad + 1)

crop1 = arr1[ymin:ymax, xmin:xmax]
crop2 = arr2[ymin:ymax, xmin:xmax]
c_diff = diff_sum[ymin:ymax, xmin:xmax]

# Let's compute alpha cleanly
# In this tight box, the background diff is under 25, edge is 25..70, body is > 70
alpha = np.clip((c_diff - 25.0) / 45.0, 0.0, 1.0)

# Smooth edges
alpha[c_diff < 20] = 0.0
alpha[c_diff > 75] = 1.0

# Restore clean foreground
fg = np.copy(crop1)
valid = (alpha > 0.05) & (alpha < 0.99)
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
print("Saved perfect tight logo_pg_clean.png:", res_img.size)
