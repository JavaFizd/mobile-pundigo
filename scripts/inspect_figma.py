from PIL import Image
import os

files = [
    'figma_designs/Untitled/HALAMAN PEMBUKA-1.png',
    'figma_designs/Untitled/PundiGo! INTRODUCE 1.png',
    'figma_designs/Untitled/PundiGo! INTRODUCE 2.png',
    'figma_designs/Untitled/DASHBOARD.png',
    'figma_designs/Untitled/DAFTAR AKUN (SEBELUM INPUT, SANDI TUTUP).png',
    'figma_designs/Untitled/MEMBUAT PIN.png'
]

for f in files:
    if os.path.exists(f):
        im = Image.open(f)
        print(f, im.size)
