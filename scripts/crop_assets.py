from PIL import Image
import numpy as np

# 1. Inspect logo in PundiGo! INTRODUCE 1.png
img = Image.open('figma_designs/Untitled/PundiGo! INTRODUCE 1.png').convert('RGBA')
arr = np.array(img)

# Logo is around y 120..240, x 160..290
crop1 = img.crop((165, 130, 290, 240))
crop1.save('assets/images/logo_crop_raw.png')

# 2. Extract Wallet from PundiGo! INTRODUCE 2.png
# Let's crop the wallet illustration
img2 = Image.open('figma_designs/Untitled/PundiGo! INTRODUCE 2.png').convert('RGBA')
crop_wallet = img2.crop((305, 440, 395, 575))
crop_wallet.save('assets/images/wallet_illustration.png')

# 3. Extract Safe/Lock from MEMBUAT PIN.png
img3 = Image.open('figma_designs/Untitled/MEMBUAT PIN.png').convert('RGBA')
crop_lock = img3.crop((35, 205, 95, 275))
crop_lock.save('assets/images/lock_illustration.png')

print("Cropped successfully")
