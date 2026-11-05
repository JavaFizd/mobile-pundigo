from PIL import Image
import numpy as np

def remove_blue_gradient_bg(img_path, out_path, bg_start, bg_end):
    """
    Remove the blue/teal gradient background from card illustrations.
    In the cards, background has specific green/blue gradient.
    """
    im = Image.open(img_path).convert('RGBA')
    arr = np.array(im, dtype=np.float32)
    h, w, _ = arr.shape

    # For each row, the background color interpolates between top and bottom
    # Let's inspect the corners of the image
    tl = arr[0, 0, :3]
    tr = arr[0, -1, :3]
    bl = arr[-1, 0, :3]
    br = arr[-1, -1, :3]
    
    print(f"{img_path} corners: TL={tl}, TR={tr}, BL={bl}, BR={br}")

remove_blue_gradient_bg('assets/images/jar_coins.png', 'assets/images/jar_coins_trans.png', None, None)
remove_blue_gradient_bg('assets/images/wallet_illustration.png', 'assets/images/wallet_trans.png', None, None)
remove_blue_gradient_bg('assets/images/lock_illustration.png', 'assets/images/lock_trans.png', None, None)
remove_blue_gradient_bg('assets/images/promo_illustration.png', 'assets/images/promo_trans.png', None, None)
