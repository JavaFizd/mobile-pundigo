import base64
import os

def b64(rel_path):
    abs_path = os.path.join(os.getcwd(), rel_path)
    with open(abs_path, 'rb') as f:
        return base64.b64encode(f.read()).decode('utf-8')

logo_pg = b64('assets/images/logo_pg_exact.png')
icon_trf = b64('assets/images/icon_action_transfer_hd.png')
icon_top = b64('assets/images/icon_action_topup_hd.png')
icon_req = b64('assets/images/icon_action_minta_hd.png')
patungan_img = b64('assets/images/patungan_illustration.png')
saku_img = b64('assets/images/saku_illustration.png')
promo_img = b64('assets/images/promo_banner_full.png')

html = f"""<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PundiGo! - 03 Beranda & Dashboard (Pixel-Perfect HD)</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
    * {{
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
      -webkit-font-smoothing: antialiased;
    }}

    body {{
      background-color: #0B0F19;
      color: #F8FAFC;
      padding: 40px;
    }}

    .module-header {{
      margin-bottom: 30px;
    }}

    .module-title {{
      font-size: 24px;
      font-weight: 800;
      color: #00BFA5;
    }}

    .figma-canvas {{
      display: flex;
      flex-wrap: wrap;
      gap: 40px;
      align-items: flex-start;
    }}

    .frame-wrapper {{
      display: flex;
      flex-direction: column;
      gap: 12px;
    }}

    .frame-tag {{
      font-size: 13px;
      font-weight: 700;
      color: #94A3B8;
      display: flex;
      align-items: center;
      gap: 8px;
    }}

    .frame-tag span {{
      background: #1E293B;
      color: #00BFA5;
      padding: 2px 8px;
      border-radius: 6px;
      font-size: 11px;
    }}

    .mobile-frame {{
      width: 390px;
      height: 844px;
      background-color: #F8FAFD;
      border-radius: 40px;
      overflow: hidden;
      position: relative;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
      color: #0F172A;
      display: flex;
      flex-direction: column;
    }}

    .header-gradient {{
      background: linear-gradient(135deg, #00BFA5 0%, #1E88E5 100%);
      padding: 24px 20px 48px 20px;
      border-bottom-left-radius: 28px;
      border-bottom-right-radius: 28px;
      color: white;
    }}

    .avatar {{
      width: 44px;
      height: 44px;
      background-color: #DCE4FD;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
      color: #1E3A8A;
      font-size: 15px;
    }}

    .quick-actions {{
      background: white;
      margin: -28px 20px 0 20px;
      padding: 16px 14px;
      border-radius: 20px;
      box-shadow: 0 10px 25px rgba(0, 168, 135, 0.08);
      display: flex;
      justify-content: space-around;
      position: relative;
      z-index: 10;
      border: 1px solid #F1F5F9;
    }}

    .action-btn {{
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
    }}

    .bottom-nav {{
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 72px;
      background: white;
      border-top: 1px solid #E2E8F0;
      display: flex;
      justify-content: space-around;
      align-items: center;
      padding-bottom: 12px;
      z-index: 50;
    }}
  </style>
</head>
<body>

  <div class="module-header">
    <div class="module-title">MODUL 03: BERANDA & DASHBOARD (PIXEL-PERFECT HD)</div>
    <div class="module-desc">100% Menggunakan Ikon Quick Actions HD Resmi, Logo PG Asli, dan Ilustrasi Banner DASHBOARD-3.png.</div>
  </div>

  <div class="figma-canvas">

    <!-- 1. BERANDA - AKUN BASIC ASLI FIGMA DASHBOARD-3.png -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>01</span> Beranda - Akun Basic (DASHBOARD-3 Asli)</div>
      <div class="mobile-frame">
        <div class="header-gradient">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 12px;">
              <div class="avatar">DS</div>
              <div>
                <div style="font-size: 11px; opacity: 0.85;">HALO,</div>
                <div style="font-size: 17px; font-weight: 800;">Dinda Syifa</div>
              </div>
            </div>
            <span style="background: rgba(255,255,255,0.2); padding: 4px 10px; border-radius: 20px; font-size: 10px; font-weight: 700;">MEMBER BARU</span>
          </div>
          <div>
            <div style="font-size: 12px; opacity: 0.85;">Saldo Utama PundiGo 👁️</div>
            <div style="font-size: 28px; font-weight: 800; margin-top: 4px; display: flex; align-items: center; gap: 8px;">
              Rp100.000
              <span style="font-size: 11px; background: rgba(255,255,255,0.25); padding: 2px 8px; border-radius: 8px;">● Akun Basic</span>
            </div>
          </div>
        </div>

        <div class="quick-actions">
          <div class="action-btn">
            <img src="data:image/png;base64,{icon_trf}" style="width: 48px; height: 48px;">
            <div style="font-size: 12px; font-weight: 700; color: #1E293B;">Transfer</div>
          </div>
          <div class="action-btn">
            <img src="data:image/png;base64,{icon_top}" style="width: 48px; height: 48px;">
            <div style="font-size: 12px; font-weight: 700; color: #1E293B;">Top Up</div>
          </div>
          <div class="action-btn">
            <img src="data:image/png;base64,{icon_req}" style="width: 48px; height: 48px;">
            <div style="font-size: 12px; font-weight: 700; color: #1E293B;">Minta</div>
          </div>
        </div>

        <div style="padding: 24px 20px 80px 20px; overflow-y: auto;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; font-size: 14.5px; font-weight: 800;">
            <span style="color: #0F172A;">Uangmu, lebih teratur</span>
            <span style="color: #00A887; font-size: 12px;">Fitur Cerdas &gt;</span>
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 18px;">
            <div style="background: white; border: 1px solid #E2E8F0; padding: 14px; border-radius: 18px; box-shadow: 0 4px 10px rgba(0,0,0,0.02);">
              <img src="data:image/png;base64,{patungan_img}" style="width: 38px; height: 38px; margin-bottom: 6px;">
              <div style="font-size: 13px; font-weight: 800; color: #0F172A;">Patungan Pintar</div>
              <div style="font-size: 10.5px; color: #64748B; margin-top: 2px;">Bagi tagihan makan bebas ribut</div>
            </div>
            <div style="background: white; border: 1px solid #E2E8F0; padding: 14px; border-radius: 18px; box-shadow: 0 4px 10px rgba(0,0,0,0.02);">
              <img src="data:image/png;base64,{saku_img}" style="width: 38px; height: 38px; margin-bottom: 6px;">
              <div style="font-size: 13px; font-weight: 800; color: #0F172A;">Saku Bersama</div>
              <div style="font-size: 10.5px; color: #64748B; margin-top: 2px;">Kelola uang kas kelompok & kost</div>
            </div>
          </div>

          <!-- PROMO BANNER ASLI FIGMA -->
          <img src="data:image/png;base64,{promo_img}" style="width: 100%; border-radius: 18px; box-shadow: 0 8px 16px rgba(0,0,0,0.06);">
        </div>

        <div class="bottom-nav">
          <div style="color: #00A887; font-size: 11px; font-weight: 700; text-align: center;">🏠<br>Beranda</div>
          <div style="color: #94A3B8; font-size: 11px; text-align: center;">💡<br>Fitur</div>
          <div style="color: #94A3B8; font-size: 11px; text-align: center;">🕒<br>Riwayat</div>
          <div style="color: #94A3B8; font-size: 11px; text-align: center;">👤<br>Profil</div>
        </div>
      </div>
    </div>

  </div>

</body>
</html>
"""

with open('figma_export/03_beranda_dashboard.html', 'w', encoding='utf-8') as f:
    f.write(html)

# Also update the standalone test file
with open('figma_test_dashboard.html', 'w', encoding='utf-8') as f:
    f.write(html)

print('Successfully generated 03_beranda_dashboard.html with exact HD assets!')
