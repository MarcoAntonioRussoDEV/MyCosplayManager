"""Genera le icone PWA della dashboard admin (192/512/maskable). Stesso approccio
del corrispettivo script in Unwaste (scripts/gen_pwa_icons.py): forma semplice,
nessun asset esterno, rigenerabile in un secondo se cambia la palette."""
from PIL import Image, ImageDraw, ImageFont

BG = (26, 15, 46)  # deepPurple molto scuro, coerente col tema dell'app mobile
FG = (191, 165, 255)  # lilla chiaro


def draw_mark(draw: ImageDraw.ImageDraw, size: int, scale: float = 1.0):
    # Semplice gruccia stilizzata (coerente con l'icona hanger dell'app mobile),
    # ridotta a poche linee spesse per restare leggibile anche piccola.
    cx, cy = size / 2, size / 2
    s = size * 0.30 * scale
    stroke = max(4, int(size * 0.045 * scale))
    hook_r = s * 0.28
    draw.arc(
        [cx - hook_r, cy - s - hook_r * 1.6, cx + hook_r, cy - s + hook_r * 0.4],
        200, 340, fill=FG, width=stroke,
    )
    draw.line([cx, cy - s * 0.7, cx, cy - s * 0.15], fill=FG, width=stroke)
    draw.line([cx, cy - s * 0.15, cx - s, cy + s * 0.65], fill=FG, width=stroke, joint="curve")
    draw.line([cx, cy - s * 0.15, cx + s, cy + s * 0.65], fill=FG, width=stroke, joint="curve")
    draw.line([cx - s, cy + s * 0.65, cx + s, cy + s * 0.65], fill=FG, width=stroke, joint="curve")


def make_icon(path: str, size: int, maskable: bool = False):
    img = Image.new("RGB", (size, size), BG)
    draw = ImageDraw.Draw(img)
    # Maskable: Android ritaglia in un cerchio centrale, serve un margine di sicurezza (safe zone ~66%).
    draw_mark(draw, size, scale=0.72 if maskable else 1.0)
    img.save(path, "PNG")


if __name__ == "__main__":
    make_icon("public/pwa/icon-192.png", 192)
    make_icon("public/pwa/icon-512.png", 512)
    make_icon("public/pwa/maskable-512.png", 512, maskable=True)
    print("Icone PWA generate in public/pwa/")
