import base64
import os

def b64(rel_path):
    abs_path = os.path.join(os.getcwd(), rel_path)
    with open(abs_path, 'rb') as f:
        return base64.b64encode(f.read()).decode('utf-8')

logo_full = b64('assets/images/logo_pundigo_full.png')
logo_text = b64('assets/images/logo_pundigo_text.png')
card1 = b64('assets/images/intro_card_1_hd.png')
card2 = b64('assets/images/intro_card_2_hd.png')
logo_pg = b64('assets/images/logo_pg_exact.png')
logo_splash = b64('assets/images/logo_splash.png')

html = f"""<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PundiGo! - 01 Auth & Onboarding (Pixel-Perfect HD)</title>
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

    .module-desc {{
      font-size: 14px;
      color: #94A3B8;
      margin-top: 4px;
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
      border-radius: 40px;
      overflow: hidden;
      position: relative;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
      color: #0F172A;
      display: flex;
      flex-direction: column;
    }}

    /* ONBOARDING STYLES */
    .onboard-container {{
      flex: 1;
      padding: 24px 24px 30px 24px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      background: #FFFFFF;
      position: relative;
    }}

    .onboard-top {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 28px;
    }}

    .onboard-center {{
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: auto 0;
    }}

    .onboard-btn {{
      width: 100%;
      height: 52px;
      background: linear-gradient(90deg, #00C9A7 0%, #2979FF 100%);
      color: white;
      border: none;
      border-radius: 16px;
      font-size: 15px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 8px 18px rgba(0, 201, 167, 0.35);
      cursor: pointer;
    }}

    /* FORM STYLES */
    .form-container {{
      flex: 1;
      padding: 24px 24px 28px 24px;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
    }}

    .form-header {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }}

    .form-banner {{
      background: linear-gradient(135deg, #00BFA5 0%, #1E88E5 100%);
      border-radius: 20px;
      padding: 20px;
      color: white;
      margin-bottom: 22px;
      box-shadow: 0 8px 20px rgba(0, 191, 165, 0.25);
    }}

    .form-label {{
      font-size: 12px;
      font-weight: 700;
      color: #334155;
      margin-bottom: 6px;
      display: block;
    }}

    .form-input {{
      width: 100%;
      height: 48px;
      background: #F8FAFC;
      border: 1.5px solid #E2E8F0;
      border-radius: 14px;
      padding: 0 16px;
      font-size: 13.5px;
      color: #0F172A;
      display: flex;
      align-items: center;
      margin-bottom: 14px;
    }}

    .form-input.filled {{
      border-color: #00BFA5;
      background: #FFFFFF;
      font-weight: 600;
    }}

    .btn-submit {{
      width: 100%;
      height: 50px;
      background: linear-gradient(135deg, #00BFA5 0%, #1E88E5 100%);
      color: white;
      border: none;
      border-radius: 16px;
      font-size: 14.5px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      cursor: pointer;
      box-shadow: 0 8px 18px rgba(0, 191, 165, 0.3);
      margin-top: 10px;
    }}

    .btn-disabled {{
      width: 100%;
      height: 50px;
      background: #E2E8F0;
      color: #94A3B8;
      border: none;
      border-radius: 16px;
      font-size: 14.5px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-top: 10px;
    }}

    .keypad-grid {{
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 14px;
      margin-top: auto;
      margin-bottom: 20px;
      padding: 0 20px;
    }}

    .keypad-btn {{
      height: 56px;
      background: #F8FAFC;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      font-weight: 700;
      color: #0F172A;
    }}
  </style>
</head>
<body>

  <div class="module-header">
    <div class="module-title">MODUL 01: ONBOARDING & AUTH (PIXEL-PERFECT FIGMA)</div>
    <div class="module-desc">100% Menggunakan Aset 3D HD Asli, Font Plus Jakarta Sans, dan Desain Layar Sesuai Flutter.</div>
  </div>

  <div class="figma-canvas">

    <!-- 1. SPLASH SCREEN ASLI -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>01</span> Splash Screen (Asli)</div>
      <div class="mobile-frame" style="background: linear-gradient(135deg, #00BFA5 0%, #1E88E5 100%); display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; color: white;">
        <img src="data:image/png;base64,{logo_splash}" style="width: 130px; height: 130px; margin-bottom: 16px;">
        <div style="font-size: 32px; font-weight: 800; letter-spacing: -0.5px;">PundiGo!</div>
        <div style="font-size: 13.5px; opacity: 0.9; margin-top: 6px;">Dompet Cerdas Mahasiswa & Generasi Muda</div>
        <div style="margin-top: 60px; font-size: 11.5px; opacity: 0.75;">● ● ● Dilindungi Enkripsi Bank</div>
      </div>
    </div>

    <!-- 2. ONBOARDING 1 ASLI (NABUNG RECEH & TOPLES 3D) -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>02</span> Onboarding 1 - Nabung Receh (3D)</div>
      <div class="mobile-frame">
        <div class="onboard-container">
          <!-- HEADER -->
          <div class="onboard-top">
            <img src="data:image/png;base64,{logo_text}" style="height: 20px; object-fit: contain;">
            <span style="font-size: 13.5px; font-weight: 600; color: #4A5568;">Lewati ➔</span>
          </div>

          <!-- LOGO PUSAT + KARTU 3D ASLI FIGMA -->
          <div class="onboard-center">
            <img src="data:image/png;base64,{logo_full}" style="width: 155px; margin-bottom: 20px;">
            <img src="data:image/png;base64,{card1}" style="width: 342px; border-radius: 20px; box-shadow: 0 12px 30px rgba(0,0,0,0.08);">
          </div>

          <!-- INDIKATOR TITIK & TOMBOL LANJUTKAN -->
          <div>
            <div style="display: flex; gap: 6px; margin-bottom: 18px;">
              <div style="width: 24px; height: 5px; background: #00A887; border-radius: 4px;"></div>
              <div style="width: 6px; height: 5px; background: #D1D5DB; border-radius: 4px;"></div>
            </div>
            <button class="onboard-btn">Lanjutkan ➔</button>
            <div style="text-align: center; margin-top: 12px; font-size: 13px; color: #64748B;">
              Sudah punya akun? <strong style="color: #00A887;">Masuk</strong>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 3. ONBOARDING 2 ASLI (PATUNGAN SANTAI & DOMPET 3D) -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>03</span> Onboarding 2 - Patungan Santai (3D)</div>
      <div class="mobile-frame">
        <div class="onboard-container">
          <!-- HEADER -->
          <div class="onboard-top">
            <img src="data:image/png;base64,{logo_text}" style="height: 20px; object-fit: contain;">
            <span style="width: 60px;"></span>
          </div>

          <!-- LOGO PUSAT + KARTU 3D ASLI FIGMA -->
          <div class="onboard-center">
            <img src="data:image/png;base64,{logo_full}" style="width: 155px; margin-bottom: 20px;">
            <img src="data:image/png;base64,{card2}" style="width: 342px; border-radius: 20px; box-shadow: 0 12px 30px rgba(0,0,0,0.08);">
          </div>

          <!-- INDIKATOR TITIK & TOMBOL DAFTAR -->
          <div>
            <div style="display: flex; gap: 6px; margin-bottom: 18px;">
              <div style="width: 6px; height: 5px; background: #D1D5DB; border-radius: 4px;"></div>
              <div style="width: 24px; height: 5px; background: #00A887; border-radius: 4px;"></div>
            </div>
            <button class="onboard-btn">Daftar Akun Baru ➔</button>
            <div style="text-align: center; margin-top: 12px; font-size: 13px; color: #64748B;">
              Sudah punya akun? <strong style="color: #00A887;">Masuk</strong>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 4. DAFTAR AKUN BARU (FORM KOSONG ASLI FIGMA) -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>04</span> Register - Form Kosong (Figma Asli)</div>
      <div class="mobile-frame">
        <div class="form-container">
          <div class="form-header">
            <img src="data:image/png;base64,{logo_pg}" style="width: 32px; height: 32px;">
            <span style="font-size: 20px; font-weight: 800; color: #1E293B;">PundiGo!</span>
          </div>

          <div class="form-banner">
            <div style="font-size: 18px; font-weight: 800;">Daftar Akun Baru</div>
            <div style="font-size: 12px; opacity: 0.9; margin-top: 4px;">Isi data diri Anda untuk membuat akun PundiGo!</div>
          </div>

          <label class="form-label">Nama Lengkap</label>
          <div class="form-input" style="color: #94A3B8;">Contoh: Dinda Syahfitri</div>

          <label class="form-label">Nomor Handphone</label>
          <div class="form-input" style="color: #94A3B8;">+62 &nbsp; 812-xxxx-xxxx</div>

          <label class="form-label">Alamat Email</label>
          <div class="form-input" style="color: #94A3B8;">nama@domain.com</div>

          <label class="form-label">Kata Sandi</label>
          <div class="form-input" style="display: flex; justify-content: space-between; color: #94A3B8;">
            <span>Min. 8 karakter kombinasi</span>
            <span>👁️</span>
          </div>

          <div style="display: flex; align-items: center; gap: 8px; margin: 8px 0 16px 0;">
            <input type="checkbox" style="accent-color: #00BFA5; width: 16px; height: 16px;">
            <span style="font-size: 11px; color: #64748B;">Saya menyetujui Syarat & Kebijakan Privasi</span>
          </div>

          <button class="btn-disabled">Kirim Kode OTP</button>

          <div style="text-align: center; margin-top: auto; font-size: 13px; color: #64748B;">
            Sudah punya akun? <strong style="color: #00A887;">Masuk</strong>
          </div>
        </div>
      </div>
    </div>

    <!-- 5. DAFTAR AKUN BARU (FORM TERISI AKTIF) -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>05</span> Register - Form Terisi (Figma Asli)</div>
      <div class="mobile-frame">
        <div class="form-container">
          <div class="form-header">
            <img src="data:image/png;base64,{logo_pg}" style="width: 32px; height: 32px;">
            <span style="font-size: 20px; font-weight: 800; color: #1E293B;">PundiGo!</span>
          </div>

          <div class="form-banner">
            <div style="font-size: 18px; font-weight: 800;">Daftar Akun Baru</div>
            <div style="font-size: 12px; opacity: 0.9; margin-top: 4px;">Isi data diri Anda untuk membuat akun PundiGo!</div>
          </div>

          <label class="form-label">Nama Lengkap</label>
          <div class="form-input filled">Dinda Syahfitri</div>

          <label class="form-label">Nomor Handphone</label>
          <div class="form-input filled">+62 &nbsp; 82501800288</div>

          <label class="form-label">Alamat Email</label>
          <div class="form-input filled">alhamdulillah.dinda@gmail.com</div>

          <label class="form-label">Kata Sandi</label>
          <div class="form-input filled" style="display: flex; justify-content: space-between;">
            <span>••••••••••</span>
            <span>👁️</span>
          </div>

          <div style="display: flex; align-items: center; gap: 8px; margin: 8px 0 16px 0;">
            <input type="checkbox" checked style="accent-color: #00BFA5; width: 16px; height: 16px;">
            <span style="font-size: 11px; color: #00A887; font-weight: 700;">✓ Syarat & Ketentuan disetujui</span>
          </div>

          <button class="btn-submit">Kirim Kode via WhatsApp ➔</button>

          <div style="text-align: center; margin-top: auto; font-size: 13px; color: #64748B;">
            Sudah punya akun? <strong style="color: #00A887;">Masuk</strong>
          </div>
        </div>
      </div>
    </div>

    <!-- 6. MASUKKAN PIN KEAMANAN ASLI -->
    <div class="frame-wrapper">
      <div class="frame-tag"><span>06</span> Input PIN 6-Digit (Asli)</div>
      <div class="mobile-frame" style="padding: 30px 20px; text-align: center;">
        <div style="display: flex; justify-content: center; margin-bottom: 12px;">
          <img src="data:image/png;base64,{logo_pg}" style="width: 36px; height: 36px;">
        </div>
        <div style="font-size: 20px; font-weight: 800; color: #0F172A;">Masukkan PIN PundiGo!</div>
        <div style="font-size: 12.5px; color: #64748B; margin-top: 4px;">Konfirmasi PIN keamanan 6-digit akunmu</div>

        <div style="display: flex; justify-content: center; gap: 14px; margin: 36px 0;">
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #00A887; box-shadow: 0 0 10px rgba(0,168,135,0.4);"></div>
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #00A887; box-shadow: 0 0 10px rgba(0,168,135,0.4);"></div>
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #00A887; box-shadow: 0 0 10px rgba(0,168,135,0.4);"></div>
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #E2E8F0;"></div>
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #E2E8F0;"></div>
          <div style="width: 16px; height: 16px; border-radius: 50%; background: #E2E8F0;"></div>
        </div>

        <div class="keypad-grid">
          <div class="keypad-btn">1</div><div class="keypad-btn">2</div><div class="keypad-btn">3</div>
          <div class="keypad-btn">4</div><div class="keypad-btn">5</div><div class="keypad-btn">6</div>
          <div class="keypad-btn">7</div><div class="keypad-btn">8</div><div class="keypad-btn">9</div>
          <div class="keypad-btn" style="font-size: 12px; color: #64748B;">Lupa?</div><div class="keypad-btn">0</div><div class="keypad-btn">⌫</div>
        </div>
      </div>
    </div>

  </div>

</body>
</html>
"""

os.makedirs('figma_export', exist_ok=True)
with open('figma_export/01_auth_onboarding.html', 'w', encoding='utf-8') as f:
    f.write(html)

print('Successfully generated 01_auth_onboarding.html with exact HD assets!')
