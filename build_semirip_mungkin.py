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

# ==============================================================================
# 01 AUTH & ONBOARDING (100% PERSIS SCREENSHOT FIGMA)
# ==============================================================================
html_01 = f"""<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PundiGo! - 01 Auth & Onboarding (100% Persis Figma)</title>
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

    /* EXACT IPHONE 14/15 FRAME (390 x 844) */
    .mobile-frame {{
      width: 390px;
      height: 844px;
      background-color: #FFFFFF;
      border-radius: 44px;
      overflow: hidden;
      position: relative;
      box-shadow: 0 25px 50px rgba(0, 0, 0, 0.55);
      color: #0F172A;
      display: flex;
      flex-direction: column;
      border: 3px solid #1E293B;
    }}

    /* IPHONE STATUS BAR WITH DYNAMIC ISLAND */
    .status-bar {{
      height: 48px;
      padding: 12px 24px 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
      z-index: 100;
    }}

    .status-time {{
      font-size: 14px;
      font-weight: 700;
      color: #0F172A;
      letter-spacing: -0.2px;
    }}

    .dynamic-island {{
      width: 110px;
      height: 30px;
      background: #000000;
      border-radius: 20px;
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
      top: 10px;
    }}

    .status-icons {{
      display: flex;
      gap: 6px;
      align-items: center;
      font-size: 12px;
      color: #0F172A;
      font-weight: 700;
    }}

    /* PILL BUTTONS (100% PERSIS FIGMA) */
    .btn-pill-gradient {{
      width: 100%;
      height: 54px;
      background: linear-gradient(90deg, #00BFA5 0%, #1E88E5 100%);
      color: white;
      border: none;
      border-radius: 27px;
      font-size: 15px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      cursor: pointer;
      box-shadow: 0 10px 24px rgba(0, 191, 165, 0.35);
    }}

    .btn-pill-disabled {{
      width: 100%;
      height: 54px;
      background: #E2E8F0;
      color: #94A3B8;
      border: none;
      border-radius: 27px;
      font-size: 15px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
    }}

    /* CUSTOM FIELDS (PERSIS phone_screen_3.png) */
    .field-label {{
      font-size: 13.5px;
      font-weight: 700;
      color: #1E293B;
      margin-bottom: 7px;
      display: block;
    }}

    .field-box {{
      width: 100%;
      height: 52px;
      background: #EDF2F7;
      border-radius: 16px;
      padding: 0 16px;
      font-size: 14.5px;
      color: #1E293B;
      display: flex;
      align-items: center;
      margin-bottom: 16px;
      border: 1px solid transparent;
    }}

    .field-box.error {{
      border-color: #EF4444;
      background: #FEF2F2;
    }}

    /* KEYPAD SOFT (PERSIS phone_screen_1.png) */
    .keypad-container {{
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      padding: 0 20px;
      margin-top: auto;
      margin-bottom: 24px;
    }}

    .keypad-key {{
      height: 56px;
      background: #F8FAFC;
      border-radius: 16px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: #0F172A;
      box-shadow: 0 2px 4px rgba(0,0,0,0.02);
    }}

    .key-num {{ font-size: 20px; font-weight: 700; line-height: 1.1; }}
    .key-sub {{ font-size: 9px; font-weight: 700; color: #94A3B8; letter-spacing: 1px; }}
  </style>
</head>
<body>

  <div class="module-header">
    <div class="module-title">MODUL 01: ONBOARDING & AUTH (100% PERSIS FIGMA)</div>
    <div class="module-desc">Direkonstruksi 100% pixel-perfect berdasarkan screenshot asli: phone_loading_3.png, phone_screen_2.png, phone_screen_3.png, dan phone_screen_1.png.</div>
  </div>

  <div class="figma-canvas">

    <!-- ========================================================================= -->
    <!-- 1. SPLASH / LOADING SCREEN (100% PERSIS phone_loading_3.png) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>01</span> Splash & Loading Screen (phone_loading_3.png)</div>
      <div class="mobile-frame" style="background: radial-gradient(circle at 10% 10%, #E6F8F5 0%, #FFFFFF 50%, #EFF6FF 100%); justify-content: space-between; align-items: center; padding: 0 24px 60px 24px; text-align: center;">
        <!-- Status Bar -->
        <div class="status-bar" style="width: 100%;">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <!-- Center Content -->
        <div style="display: flex; flex-direction: column; align-items: center; margin: auto 0;">
          <!-- 3D PG Logo -->
          <img src="data:image/png;base64,{logo_pg_exact}" style="width: 110px; height: 110px; margin-bottom: 24px; filter: drop-shadow(0 12px 24px rgba(0, 191, 165, 0.25));">
          
          <!-- Badge Pill -->
          <div style="background: #E6F8F5; color: #00A887; border: 1px solid #A7F3D0; font-size: 11px; font-weight: 800; padding: 5px 14px; border-radius: 20px; margin-bottom: 12px; letter-spacing: 0.3px;">
            ✦ Dompet Pintar Generasi Maju
          </div>

          <!-- Slogan -->
          <div style="font-size: 16px; font-weight: 700; color: #334155; letter-spacing: -0.2px;">
            Cerdas Kelola, Cepat Bertumbuh
          </div>

          <!-- Loading Progress Bar (45%) -->
          <div style="width: 260px; height: 5px; background: #E2E8F0; border-radius: 4px; overflow: hidden; margin-top: 36px;">
            <div style="width: 45%; height: 100%; background: linear-gradient(90deg, #00BFA5, #2979FF); border-radius: 4px;"></div>
          </div>

          <div style="width: 260px; display: flex; justify-content: space-between; font-size: 11px; color: #64748B; font-weight: 600; margin-top: 8px;">
            <span>Menghubungkan jaringan terenkripsi...</span>
            <span style="color: #00A887; font-weight: 800;">45%</span>
          </div>
        </div>

        <div style="font-size: 11px; color: #94A3B8;">Dilindungi Enkripsi Keamanan Bank Indonesia</div>
      </div>
    </div>

    <!-- ========================================================================= -->
    <!-- 2. ONBOARDING 1 (100% PERSIS phone_screen_2.png) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>02</span> Onboarding Slide 1 (phone_screen_2.png)</div>
      <div class="mobile-frame">
        <!-- Status Bar -->
        <div class="status-bar">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <div style="flex: 1; padding: 12px 24px 28px 24px; display: flex; flex-direction: column; justify-content: space-between;">
          <!-- Header Bar: PundiGo! & Lewati ➔ -->
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 19px; font-weight: 800; color: #0F172A; letter-spacing: -0.4px;">PundiGo!</span>
            <span style="font-size: 13.5px; font-weight: 700; color: #4A5568;">Lewati ➔</span>
          </div>

          <!-- Brand Lockup Pusat: Logo PG + PundiGo! -->
          <div style="display: flex; flex-direction: column; align-items: center; margin: 10px 0 16px 0;">
            <img src="data:image/png;base64,{logo_pg_exact}" style="width: 58px; height: 58px; margin-bottom: 8px;">
            <div style="font-size: 24px; font-weight: 800; color: #0F172A; letter-spacing: -0.5px;">PundiGo!</div>
          </div>

          <!-- Kartu Fitur 3D Resmi Figma (Nabung Receh & Toples Emas) -->
          <div style="width: 100%; border-radius: 24px; overflow: hidden; box-shadow: 0 14px 34px rgba(0, 191, 165, 0.22); margin-bottom: 20px;">
            <img src="data:image/png;base64,{card1}" style="width: 100%; display: block; object-fit: contain;">
          </div>

          <!-- Indikator Titik -->
          <div style="display: flex; gap: 6px; margin-bottom: 18px;">
            <div style="width: 24px; height: 5px; background: #00A887; border-radius: 4px;"></div>
            <div style="width: 6px; height: 5px; background: #E2E8F0; border-radius: 4px;"></div>
          </div>

          <!-- Tombol Pill Lanjutkan ➔ -->
          <button class="btn-pill-gradient">Lanjutkan ➔</button>
        </div>
      </div>
    </div>

    <!-- ========================================================================= -->
    <!-- 3. ONBOARDING 2 (PATUNGAN SANTAI & DOMPET 3D) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>03</span> Onboarding Slide 2 (Resmi Figma)</div>
      <div class="mobile-frame">
        <!-- Status Bar -->
        <div class="status-bar">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <div style="flex: 1; padding: 12px 24px 28px 24px; display: flex; flex-direction: column; justify-content: space-between;">
          <!-- Header Bar: PundiGo! & Kosong (Slide Terakhir) -->
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 19px; font-weight: 800; color: #0F172A; letter-spacing: -0.4px;">PundiGo!</span>
            <span style="width: 50px;"></span>
          </div>

          <!-- Brand Lockup Pusat: Logo PG + PundiGo! -->
          <div style="display: flex; flex-direction: column; align-items: center; margin: 10px 0 16px 0;">
            <img src="data:image/png;base64,{logo_pg_exact}" style="width: 58px; height: 58px; margin-bottom: 8px;">
            <div style="font-size: 24px; font-weight: 800; color: #0F172A; letter-spacing: -0.5px;">PundiGo!</div>
          </div>

          <!-- Kartu Fitur 3D Resmi Figma (Patungan Santai & Dompet Mint) -->
          <div style="width: 100%; border-radius: 24px; overflow: hidden; box-shadow: 0 14px 34px rgba(0, 191, 165, 0.22); margin-bottom: 20px;">
            <img src="data:image/png;base64,{card2}" style="width: 100%; display: block; object-fit: contain;">
          </div>

          <!-- Indikator Titik -->
          <div style="display: flex; gap: 6px; margin-bottom: 18px;">
            <div style="width: 6px; height: 5px; background: #E2E8F0; border-radius: 4px;"></div>
            <div style="width: 24px; height: 5px; background: #00A887; border-radius: 4px;"></div>
          </div>

          <!-- Tombol Pill Daftar Akun Baru ➔ -->
          <button class="btn-pill-gradient">Daftar Akun Baru ➔</button>
        </div>
      </div>
    </div>

    <!-- ========================================================================= -->
    <!-- 4. DAFTAR AKUN BARU - FORM TERISI (100% PERSIS phone_screen_3.png) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>04</span> Daftar Akun Baru - Terisi (phone_screen_3.png)</div>
      <div class="mobile-frame">
        <!-- Status Bar -->
        <div class="status-bar">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <div style="flex: 1; padding: 10px 24px 28px 24px; display: flex; flex-direction: column; overflow-y: auto;">
          <!-- Top Header: Logo PG kiri + PundiGo! kanan -->
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <img src="data:image/png;base64,{logo_pg_exact}" style="width: 32px; height: 32px;">
            <span style="font-size: 22px; font-weight: 800; color: #1E293B; letter-spacing: -0.4px;">PundiGo!</span>
          </div>

          <!-- Card Gradien Toska-Biru: "Daftar Akun Baru" -->
          <div style="background: linear-gradient(135deg, #00BFA5 0%, #1E88E5 100%); border-radius: 22px; padding: 20px; color: white; margin-bottom: 20px; box-shadow: 0 8px 22px rgba(0, 191, 165, 0.28);">
            <div style="font-size: 20px; font-weight: 800; letter-spacing: -0.3px;">Daftar Akun Baru</div>
            <div style="font-size: 12px; opacity: 0.92; margin-top: 6px; line-height: 1.4;">
              Buat akun PundiGo! kamu untuk menikmati akses transfer gratis, split bill cerdas, dan bunga tabungan harian.
            </div>
          </div>

          <!-- Field 1: Nama Pengguna -->
          <label class="field-label">Nama Pengguna</label>
          <div class="field-box">Dinda Syahfitri</div>

          <!-- Field 2: Nomor Ponsel -->
          <label class="field-label">Nomor Ponsel</label>
          <div class="field-box" style="display: flex; align-items: center; gap: 10px;">
            <span style="font-weight: 700; color: #0F172A;">+62</span>
            <span style="color: #CBD5E1;">|</span>
            <span style="font-weight: 600;">82501800288</span>
          </div>

          <!-- Field 3: Alamat Email -->
          <label class="field-label">Alamat Email</label>
          <div class="field-box" style="display: flex; align-items: center; gap: 10px;">
            <span style="color: #64748B; font-size: 16px;">@</span>
            <span>dinda.syahfitri@gmail.com</span>
          </div>

          <!-- Field 4: Kata Sandi -->
          <label class="field-label">Kata Sandi</label>
          <div class="field-box" style="display: flex; justify-content: space-between; align-items: center;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="color: #64748B; font-size: 16px;">🔑</span>
              <span>••••••••••</span>
            </div>
            <span style="color: #64748B; font-size: 16px;">👁️</span>
          </div>

          <!-- Checkbox Persetujuan S&K -->
          <div style="display: flex; align-items: flex-start; gap: 10px; margin: 4px 0 20px 0;">
            <div style="width: 18px; height: 18px; background: #00BFA5; border-radius: 5px; display: flex; align-items: center; justify-content: center; color: white; font-size: 11px; font-weight: 800; margin-top: 1px;">
              ✓
            </div>
            <span style="font-size: 11px; color: #64748B; line-height: 1.4;">
              Saya setuju dengan Syarat Penggunaan dan Kebijakan Privasi PundiGo!
            </span>
          </div>

          <!-- Tombol Pill: Kirim kode OTP via WhatsApp ➔ -->
          <button class="btn-pill-gradient" style="margin-top: auto;">
            Kirim kode OTP via WhatsApp ➔
          </button>
        </div>
      </div>
    </div>

    <!-- ========================================================================= -->
    <!-- 5. MASUKKAN KODE OTP (100% PERSIS phone_screen_1.png) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>05</span> Verifikasi Kode OTP (phone_screen_1.png)</div>
      <div class="mobile-frame">
        <!-- Status Bar -->
        <div class="status-bar">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <div style="flex: 1; padding: 10px 24px 20px 24px; display: flex; flex-direction: column; text-align: center;">
          <!-- Top Bar: Panah Kembali + Verifikasi -->
          <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px;">
            <span style="font-size: 20px; color: #0F172A; cursor: pointer;">←</span>
            <span style="font-size: 16px; font-weight: 800; color: #0F172A;">Verifikasi</span>
          </div>

          <!-- Judul Utama -->
          <div style="font-size: 22px; font-weight: 800; color: #0F172A;">Masukkan Kode OTP</div>
          <div style="font-size: 12.5px; color: #64748B; margin-top: 6px; line-height: 1.4;">
            Kode verifikasi 6 digit telah dikirimkan ke WhatsApp nomor
          </div>

          <!-- Pill WhatsApp & Ubah Nomor -->
          <div style="display: inline-flex; align-items: center; justify-content: center; gap: 8px; background: #F8FAFC; border: 1px solid #E2E8F0; padding: 8px 16px; border-radius: 20px; margin: 16px auto; font-size: 12.5px;">
            <span style="color: #25D366; font-size: 16px;">💬</span>
            <strong style="color: #0F172A;">+62 82501800288</strong>
            <span style="color: #CBD5E1;">•</span>
            <span style="color: #00A887; font-weight: 700; cursor: pointer;">Ubah Nomor ✏️</span>
          </div>

          <!-- 6 Kotak Digit OTP (Kotak 1 Aktif Hijau Kursor, 5 Lainnya Titik Bulat) -->
          <div style="display: flex; justify-content: center; gap: 10px; margin: 20px 0;">
            <!-- Digit 1: Aktif Hijau -->
            <div style="width: 46px; height: 56px; background: #00BFA5; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px; font-weight: 300;">
              |
            </div>
            <!-- Digit 2-6: Abu-abu dengan titik -->
            <div style="width: 46px; height: 56px; background: #F1F5F9; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94A3B8; font-size: 20px;">•</div>
            <div style="width: 46px; height: 56px; background: #F1F5F9; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94A3B8; font-size: 20px;">•</div>
            <div style="width: 46px; height: 56px; background: #F1F5F9; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94A3B8; font-size: 20px;">•</div>
            <div style="width: 46px; height: 56px; background: #F1F5F9; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94A3B8; font-size: 20px;">•</div>
            <div style="width: 46px; height: 56px; background: #F1F5F9; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94A3B8; font-size: 20px;">•</div>
          </div>

          <!-- Timer Pill: Kirim ulang kode dalam 00:41 -->
          <div style="background: #EFF6FF; color: #1E40AF; padding: 6px 14px; border-radius: 16px; font-size: 11.5px; font-weight: 600; display: inline-block; margin: 0 auto 12px auto;">
            ⏱️ Kirim ulang kode dalam 00:41
          </div>

          <div style="font-size: 12px; color: #64748B;">
            Tidak menerima pesan? <strong style="color: #00A887; cursor: pointer;">Kirim via SMS ➔</strong>
          </div>

          <!-- Custom Soft Keypad Numerik Asli -->
          <div class="keypad-container">
            <div class="keypad-key"><span class="key-num">1</span><span class="key-sub">&nbsp;</span></div>
            <div class="keypad-key"><span class="key-num">2</span><span class="key-sub">ABC</span></div>
            <div class="keypad-key"><span class="key-num">3</span><span class="key-sub">DEF</span></div>
            <div class="keypad-key"><span class="key-num">4</span><span class="key-sub">GHI</span></div>
            <div class="keypad-key"><span class="key-num">5</span><span class="key-sub">JKL</span></div>
            <div class="keypad-key"><span class="key-num">6</span><span class="key-sub">MNO</span></div>
            <div class="keypad-key"><span class="key-num">7</span><span class="key-sub">PQRS</span></div>
            <div class="keypad-key"><span class="key-num">8</span><span class="key-sub">TUV</span></div>
            <div class="keypad-key"><span class="key-num">9</span><span class="key-sub">WXYZ</span></div>
            <div class="keypad-key" style="background: transparent;"></div>
            <div class="keypad-key"><span class="key-num">0</span><span class="key-sub">+</span></div>
            <div class="keypad-key" style="font-size: 20px;">⌫</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ========================================================================= -->
    <!-- 6. PENAWARAN PUNDIGO PLUS (RESMI FIGMA) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>06</span> Penawaran PundiGo Plus (Resmi Figma)</div>
      <div class="mobile-frame" style="background: #F8F9FD;">
        <!-- Status Bar -->
        <div class="status-bar">
          <span class="status-time">09:41</span>
          <div class="dynamic-island"></div>
          <span class="status-icons">📶 🛜 🔋</span>
        </div>

        <div style="flex: 1; padding: 10px 24px 28px 24px; display: flex; flex-direction: column; overflow-y: auto;">
          <!-- Top Bar -->
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <span style="font-size: 18px; font-weight: 800; color: #1E293B;">PundiGo! Plus</span>
            <img src="data:image/png;base64,{logo_pg_exact}" style="width: 28px; height: 28px;">
          </div>

          <!-- Badge Centang Hijau: PIN akun berhasil dibuat -->
          <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 14px;">
            <div style="width: 22px; height: 22px; border-radius: 50%; background: #D8F8F0; color: #00BFA5; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 800;">
              ✓
            </div>
            <span style="font-size: 13px; font-weight: 700; color: #0F172A;">PIN akun berhasil dibuat</span>
          </div>

          <h2 style="font-size: 24px; font-weight: 800; color: #0F172A; line-height: 1.25; margin-bottom: 6px;">
            Kenalan dengan<br>PundiGo! Plus
          </h2>
          <p style="font-size: 12.5px; color: #64748B; margin-bottom: 18px;">
            Mau akses lebih? Tingkatkan akunmu dengan verifikasi identitas.
          </p>

          <!-- Kartu Gradien Dompet Plus Asli -->
          <div style="width: 100%; border-radius: 18px; overflow: hidden; box-shadow: 0 10px 24px rgba(0, 191, 165, 0.22); margin-bottom: 18px;">
            <img src="data:image/png;base64,{plus_card_exact}" style="width: 100%; display: block; object-fit: contain;">
          </div>

          <!-- Kartu Syarat: KTP & Wajah -->
          <div style="background: white; border: 1px solid #E2E8F0; border-radius: 18px; padding: 16px; margin-bottom: 20px;">
            <div style="font-size: 14px; font-weight: 800; color: #0F172A;">Untuk jadi Plus, siapkan:</div>
            <div style="font-size: 11.5px; color: #64748B; margin-top: 2px; margin-bottom: 12px;">Verifikasi identitas saat kamu siap.</div>

            <div style="display: flex; flex-direction: column; gap: 10px;">
              <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 12px; padding: 10px 14px; display: flex; align-items: center; gap: 12px;">
                <span style="font-size: 20px;">🪪</span>
                <div>
                  <div style="font-size: 13px; font-weight: 700; color: #0F172A;">KTP milikmu</div>
                  <div style="font-size: 11px; color: #64748B;">Foto e-KTP jelas & tidak buram</div>
                </div>
              </div>
              <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 12px; padding: 10px 14px; display: flex; align-items: center; gap: 12px;">
                <span style="font-size: 20px;">🤳</span>
                <div>
                  <div style="font-size: 13px; font-weight: 700; color: #0F172A;">Wajah / selfie</div>
                  <div style="font-size: 11px; color: #64748B;">Pindai biometrik wajah langsung</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tombol Tingkatkan ke Plus ➔ -->
          <button class="btn-pill-gradient" style="margin-top: auto;">
            Tingkatkan ke Plus ➔
          </button>
          <div style="text-align: center; margin-top: 12px; font-size: 14px; font-weight: 700; color: #00A887; cursor: pointer;">
            Nanti saja
          </div>
        </div>
      </div>
    </div>

  </div>

</body>
</html>
"""

# ==============================================================================
# 03 BERANDA & DASHBOARD (100% PERSIS dashboard_ref.png)
# ==============================================================================
html_03 = f"""<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PundiGo! - 03 Beranda & Dashboard (100% Persis Figma)</title>
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
      background-color: #FFFFFF;
      border-radius: 44px;
      overflow: hidden;
      position: relative;
      box-shadow: 0 25px 50px rgba(0, 0, 0, 0.55);
      color: #0F172A;
      display: flex;
      flex-direction: column;
      border: 3px solid #1E293B;
    }}

    .status-bar {{
      height: 48px;
      padding: 12px 24px 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
      z-index: 100;
      color: white;
    }}

    .status-time {{ font-size: 14px; font-weight: 700; letter-spacing: -0.2px; }}
    .dynamic-island {{ width: 110px; height: 30px; background: #000000; border-radius: 20px; position: absolute; left: 50%; transform: translateX(-50%); top: 10px; }}
    .status-icons {{ display: flex; gap: 6px; font-size: 12px; font-weight: 700; }}

    /* DASHBOARD GRADIENT HEADER (PERSIS dashboard_ref.png) */
    .dashboard-header {{
      background: linear-gradient(135deg, #00A887 0%, #1565C0 100%);
      padding: 10px 20px 48px 20px;
      border-bottom-left-radius: 28px;
      border-bottom-right-radius: 28px;
      color: white;
      position: relative;
    }}

    .user-avatar {{
      width: 44px;
      height: 44px;
      background: #DCE4FD;
      color: #1E3A8A;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
      font-size: 16px;
    }}

    .bell-btn {{
      width: 38px;
      height: 38px;
      background: rgba(255,255,255,0.2);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
    }}

    /* QUICK ACTIONS OVERLAY (50% DI ATAS GRADIEN, 50% DI KANVAS PUTIH) */
    .quick-actions-card {{
      background: white;
      margin: -26px 20px 0 20px;
      padding: 16px 14px;
      border-radius: 22px;
      box-shadow: 0 10px 30px rgba(0, 168, 135, 0.12);
      display: flex;
      justify-content: space-around;
      position: relative;
      z-index: 20;
      border: 1px solid #F1F5F9;
    }}

    .action-item {{
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
      cursor: pointer;
    }}

    /* BOTTOM NAV BAR WITH FLOATING SCAN QRIS CENTER */
    .dashboard-bottom-nav {{
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 74px;
      background: white;
      border-top: 1px solid #F1F5F9;
      display: flex;
      justify-content: space-around;
      align-items: center;
      padding-bottom: 8px;
      z-index: 50;
    }}

    .nav-btn {{
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 3px;
      font-size: 10px;
      font-weight: 700;
      color: #94A3B8;
    }}

    .nav-btn.active {{ color: #00A887; }}

    .floating-qris-btn {{
      width: 54px;
      height: 54px;
      background: linear-gradient(135deg, #00BFA5 0%, #00897B 100%);
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      box-shadow: 0 8px 18px rgba(0, 191, 165, 0.4);
      margin-top: -24px;
      border: 4px solid white;
    }}
  </style>
</head>
<body>

  <div class="module-header">
    <div class="module-title">MODUL 03: BERANDA & DASHBOARD (100% PERSIS FIGMA)</div>
    <div class="module-desc">Direkonstruksi 100% pixel-perfect berdasarkan screenshot asli: dashboard_ref.png (Header, Quick Actions, Saku, Patungan, Promo, dan Floating Scan QRIS).</div>
  </div>

  <div class="figma-canvas">

    <!-- ========================================================================= -->
    <!-- 1. DASHBOARD RESMI FIGMA (100% PERSIS dashboard_ref.png) -->
    <!-- ========================================================================= -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>01</span> Beranda Utama (dashboard_ref.png)</div>
      <div class="mobile-frame">
        <!-- Header Gradient Toska-Biru -->
        <div class="dashboard-header">
          <!-- Status Bar -->
          <div class="status-bar" style="padding: 0; margin-bottom: 14px;">
            <span class="status-time">09:41</span>
            <div class="dynamic-island"></div>
            <span class="status-icons">📶 🛜 🔋</span>
          </div>

          <!-- Baris Profil: Avatar DS, Halo Dinda!, MEMBER BARU, & Lonceng -->
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <div style="display: flex; align-items: center; gap: 12px;">
              <div class="user-avatar">DS</div>
              <div>
                <div style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-size: 16px; font-weight: 800;">Halo, Dinda!</span>
                  <span style="background: rgba(255,255,255,0.22); padding: 3px 8px; border-radius: 12px; font-size: 9.5px; font-weight: 800;">MEMBER BARU</span>
                </div>
                <div style="font-size: 11px; opacity: 0.85; margin-top: 2px;">Selamat datang di PundiGo!</div>
              </div>
            </div>
            <div class="bell-btn">🔔</div>
          </div>

          <!-- Saldo Card -->
          <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
              <div style="font-size: 12px; opacity: 0.85; display: flex; align-items: center; gap: 6px;">
                Saldo Utama <span>👁️</span>
              </div>
              <div style="font-size: 32px; font-weight: 800; letter-spacing: -0.5px; margin: 2px 0 6px 0;">
                Rp0
              </div>
              <div style="display: inline-flex; align-items: center; gap: 6px; background: white; color: #00A887; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 800;">
                <span style="width: 6px; height: 6px; background: #00A887; border-radius: 50%;"></span>
                Akun Basic
              </div>
            </div>
            <div style="font-size: 12px; opacity: 0.9; font-weight: 600; display: flex; align-items: center; gap: 4px; margin-bottom: 6px;">
              💳 Dompet
            </div>
          </div>
        </div>

        <!-- Quick Actions Floating Card (Transfer, Top Up, Minta Saldo) -->
        <div class="quick-actions-card">
          <div class="action-item">
            <img src="data:image/png;base64,{icon_trf}" style="width: 44px; height: 44px;">
            <span style="font-size: 11.5px; font-weight: 700; color: #1E293B;">Transfer</span>
          </div>
          <div class="action-item">
            <img src="data:image/png;base64,{icon_top}" style="width: 44px; height: 44px;">
            <span style="font-size: 11.5px; font-weight: 700; color: #1E293B;">Top Up</span>
          </div>
          <div class="action-item">
            <img src="data:image/png;base64,{icon_req}" style="width: 44px; height: 44px;">
            <span style="font-size: 11.5px; font-weight: 700; color: #1E293B;">Minta Saldo</span>
          </div>
        </div>

        <!-- Scrollable Content -->
        <div style="flex: 1; overflow-y: auto; padding: 20px 20px 84px 20px;">
          <!-- Logo Emblem PG di Tengah -->
          <div style="display: flex; justify-content: center; margin-bottom: 16px;">
            <img src="data:image/png;base64,{logo_pg_exact}" style="width: 32px; height: 32px;">
          </div>

          <!-- Section: Uangmu, lebih teratur & Fitur Cerdas > -->
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
            <span style="font-size: 15px; font-weight: 800; color: #0F172A;">Uangmu, lebih teratur</span>
            <span style="font-size: 12px; font-weight: 700; color: #00A887; cursor: pointer;">Fitur Cerdas &gt;</span>
          </div>

          <!-- Kartu 1: Patungan Pintar (Horizontal Asli) -->
          <div style="background: white; border: 1px solid #E2E8F0; border-radius: 18px; padding: 14px; margin-bottom: 12px; display: flex; align-items: center; gap: 14px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
            <img src="data:image/png;base64,{patungan_img}" style="width: 90px; height: 60px; object-fit: contain;">
            <div style="flex: 1;">
              <div style="font-size: 13.5px; font-weight: 800; color: #0F172A;">Patungan Pintar</div>
              <div style="font-size: 11px; color: #64748B; margin-top: 2px;">Scan struk, bagi tagihan otomatis</div>
              <div style="font-size: 11px; font-weight: 700; color: #00A887; margin-top: 6px; cursor: pointer;">Mulai patungan ↗</div>
            </div>
          </div>

          <!-- Kartu 2: Saku Kelompok (Horizontal Asli) -->
          <div style="background: white; border: 1px solid #E2E8F0; border-radius: 18px; padding: 14px; margin-bottom: 16px; display: flex; align-items: center; gap: 14px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
            <img src="data:image/png;base64,{saku_img}" style="width: 90px; height: 60px; object-fit: contain;">
            <div style="flex: 1;">
              <div style="font-size: 13.5px; font-weight: 800; color: #0F172A;">Saku Kelompok</div>
              <div style="font-size: 11px; color: #64748B; margin-top: 2px;">Dompet kas bersama yang praktis</div>
              <div style="font-size: 11px; font-weight: 700; color: #00A887; margin-top: 6px; cursor: pointer;">Buka Saku ↗</div>
            </div>
          </div>

          <!-- Banner Promo Tahunan Asli -->
          <div style="width: 100%; border-radius: 20px; overflow: hidden; box-shadow: 0 8px 20px rgba(0,0,0,0.08);">
            <img src="data:image/png;base64,{promo_img}" style="width: 100%; display: block; object-fit: contain;">
          </div>
        </div>

        <!-- Dashboard Bottom Nav with Floating Scan QRIS Center -->
        <div class="dashboard-bottom-nav">
          <div class="nav-btn active">
            <span style="font-size: 18px;">🏠</span>
            <span>Beranda</span>
          </div>
          <div class="nav-btn">
            <span style="font-size: 18px;">📊</span>
            <span>Aktivitas</span>
          </div>
          <div class="floating-qris-btn">
            ⛶
          </div>
          <div class="nav-btn">
            <span style="font-size: 18px;">⊞</span>
            <span>Fitur</span>
          </div>
          <div class="nav-btn">
            <span style="font-size: 18px;">👤</span>
            <span>Profil</span>
          </div>
        </div>
      </div>
    </div>

  </div>

</body>
</html>
"""

with open('figma_export/01_auth_onboarding.html', 'w', encoding='utf-8') as f:
    f.write(html_01)

with open('figma_export/03_beranda_dashboard.html', 'w', encoding='utf-8') as f:
    f.write(html_03)

with open('figma_test_dashboard.html', 'w', encoding='utf-8') as f:
    f.write(html_03)

print("SUCCESS: 01_auth_onboarding.html and 03_beranda_dashboard.html generated semirip mungkin!")
