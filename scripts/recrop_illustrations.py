from PIL import Image

# 1. jar_coins from PundiGo! INTRODUCE 1.png
img1 = Image.open('figma_designs/Untitled/PundiGo! INTRODUCE 1.png')
crop_jar = img1.crop((255, 470, 395, 655))
crop_jar.save('assets/images/jar_coins.png')

# 2. wallet from PundiGo! INTRODUCE 2.png
img2 = Image.open('figma_designs/Untitled/PundiGo! INTRODUCE 2.png')
crop_wallet = img2.crop((300, 435, 400, 580))
crop_wallet.save('assets/images/wallet_illustration.png')

print("Refined crops saved")
