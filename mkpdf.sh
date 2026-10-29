set -e
cd /home/claude && node /tmp/claude-0/-home-claude/9a6fdcf7-847a-5b53-9eb1-6d0136ebab35/scratchpad/pdf.js
cd /home/claude/case-study && python3 -I - <<'PY'
import pikepdf, io
from PIL import Image
pdf=pikepdf.open('Leela_Shankar_Alumni_Connections_Case_Study_v2_raw.pdf')
for page in pdf.pages:
    for name,raw in list(page.get_images().items()):
        im=pikepdf.PdfImage(raw)
        try: pil=im.as_pil_image()
        except Exception: continue
        w,h=pil.size
        if w<400: continue
        scale=min(1.0,1300/max(w,h)); pil=pil.convert('RGB')
        if scale<1: pil=pil.resize((int(w*scale),int(h*scale)),Image.LANCZOS)
        buf=io.BytesIO(); pil.save(buf,'JPEG',quality=78,optimize=True)
        if len(buf.getvalue())<len(raw.read_raw_bytes()):
            raw.write(buf.getvalue(),filter=pikepdf.Name.DCTDecode); raw.ColorSpace=pikepdf.Name.DeviceRGB; raw.BitsPerComponent=8; raw.Width=pil.size[0]; raw.Height=pil.size[1]
            for k in ('DecodeParms','SMask'):
                if k in raw: del raw[k]
pdf.save('Leela_Shankar_Alumni_Connections_Case_Study_v2.pdf',compress_streams=True,object_stream_mode=pikepdf.ObjectStreamMode.generate)
PY
rm -f Leela_Shankar_Alumni_Connections_Case_Study_v2_raw.pdf raw/pg-*.png raw/sheet*.png
pdfinfo Leela_Shankar_Alumni_Connections_Case_Study_v2.pdf | grep Pages; du -sh Leela_Shankar_Alumni_Connections_Case_Study_v2.pdf
pdftoppm -r 40 -png Leela_Shankar_Alumni_Connections_Case_Study_v2.pdf raw/pg
python3 -I - <<'PY'
from PIL import Image
import glob
fs=sorted(glob.glob('raw/pg-*.png')); ims=[Image.open(f) for f in fs]
w,h=ims[0].size
for k in range(0,len(ims),4):
    grp=ims[k:k+4]; sheet=Image.new('RGB',(len(grp)*w+(len(grp)+1)*6,h+12),'#888')
    for i,im in enumerate(grp): sheet.paste(im,(6+i*(w+6),6))
    sheet.save(f'raw/sheet{k//4+1}.png')
PY
