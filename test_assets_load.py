import base64
import os

def b64(rel_path):
    abs_path = os.path.join(os.getcwd(), rel_path)
    if not os.path.exists(abs_path):
        return ""
    with open(abs_path, 'rb') as f:
        return base64.b64encode(f.read()).decode('utf-8')

# Assets
logo_splash = b64('assets/images/logo_splash.png')
logo_pg_exact = b64('assets/images/logo_pg_exact.png')
logo_pundigo_text = b64('assets/images/logo_pundigo_text.png')
logo_pundigo_full = b64('assets/images/logo_pundigo_full.png')
card1 = b64('assets/images/intro_card_1_hd.png')
card2 = b64('assets/images/intro_card_2_hd.png')
plus_card_exact = b64('assets/images/plus_offer_card_exact.png')
patungan_img = b64('assets/images/patungan_illustration.png')
saku_img = b64('assets/images/saku_illustration.png')
promo_img = b64('assets/images/promo_banner_full.png')
icon_trf = b64('assets/images/icon_action_transfer_hd.png')
icon_top = b64('assets/images/icon_action_topup_hd.png')
icon_req = b64('assets/images/icon_action_minta_hd.png')

print("Assets loaded successfully!")
