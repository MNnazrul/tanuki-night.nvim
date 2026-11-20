#!/usr/bin/env python3
"""Classify the color of tokens in a GitLab light-theme screenshot.

usage: tok.py IMAGE LINE:COL:LEN[:label] ...
  LINE  = file line number as shown in the gutter
  COL   = 0-based character column, LEN = number of characters
Prints the nearest GitLab "white" syntax color for each token.
"""
import colorsys, sys
from PIL import Image

PAL = {
    "fg #3a383d": (0x3a, 0x38, 0x3d), "comment #998": (0x99, 0x99, 0x88), "preproc #999": (0x99, 0x99, 0x99),
    "string #d14": (0xdd, 0x11, 0x44), "number #099": (0x00, 0x99, 0x99), "func #900": (0x99, 0x00, 0x00),
    "type #458": (0x44, 0x55, 0x88), "builtin #0086b3": (0x00, 0x86, 0xb3), "teal #008080": (0x00, 0x80, 0x80),
    "symbol #990073": (0x99, 0x00, 0x73), "regex #009926": (0x00, 0x99, 0x26), "heading #800080": (0x80, 0x00, 0x80),
    "tag #000080": (0x00, 0x00, 0x80), "ns #555": (0x55, 0x55, 0x55), "quote #a00": (0xaa, 0x00, 0x00),
}
CW = 7.67  # px per character at 1x


def rows(im):
    """Map gutter line numbers to y-centers using ink runs in the gutter column."""
    w, h = im.size
    g = im.convert("L")
    ink = [y >= 50 and any(g.getpixel((x, y)) < 170 for x in range(40, 92)) for y in range(h)]
    runs, start = [], None
    for y, v in enumerate(ink + [False]):
        if v and start is None:
            start = y
        elif not v and start is not None:
            if y - start >= 5:
                runs.append((start + y) // 2)
            start = None
    # rows are evenly spaced; fit y = a + b*i so a missed/merged row can't shift the rest
    if len(runs) < 20 or runs[0] > 70:  # gutter unreadable (selection, odd crop): standard GitLab grid
        return [y for y in (round(57.5 + 19.07 * i) for i in range(48)) if y < h - 7]
    diffs = sorted(b - a for a, b in zip(runs, runs[1:]) if b - a < 30)
    if not diffs:
        return runs
    pitch = diffs[len(diffs) // 2]
    idx = [round((y - runs[0]) / pitch) for y in runs]
    n = len(runs)
    mi, my = sum(idx) / n, sum(runs) / n
    b = sum((i - mi) * (y - my) for i, y in zip(idx, runs)) / sum((i - mi) ** 2 for i in idx)
    a = my - b * mi
    return [y for y in (round(a + b * i) for i in range(idx[-1] + 1)) if y < h - 7]


def code_x0(im):
    w, h = im.size
    g = im.convert("L")
    for x in range(98, 140):  # first column right of the gutter border that has ink
        if sum(1 for y in range(55, min(h, 800)) if g.getpixel((x, y)) < 170) > 6:
            return x
    return 107


def classify(px):
    ink = sorted((sum(p), p) for p in px if min(p) < 205)
    if len(ink) < 6:
        return "?", None
    core = [p for _, p in ink[: max(4, len(ink) // 4)]]
    avg = tuple(sum(c[i] for c in core) / len(core) for i in range(3))
    hexv = "#%02x%02x%02x" % tuple(int(v) for v in avg)
    chroma = max(avg) - min(avg)
    if chroma < 11:  # grey family: fg (dark) vs comment/preproc (light)
        lum = sum(avg) / 3
        bold = len(ink) / max(1, len(px))
        return ("fg #3a383d" if lum < 128 else "grey #999/#998"), hexv
    h = colorsys.rgb_to_hls(*(v / 255 for v in avg))[0] * 360
    best, bd = None, 1e9
    for name, ref in PAL.items():
        rh, rl, rs = colorsys.rgb_to_hls(*(v / 255 for v in ref))
        if rs < 0.15:
            continue
        d = min(abs(h - rh * 360), 360 - abs(h - rh * 360))
        if d < bd:
            bd, best = d, name
    if best in ("teal #008080", "number #099"):
        best = "teal/num #008080|#099"
    return f"{best} (h={h:.0f})", hexv


def main():
    im = Image.open(sys.argv[1]).convert("RGB")
    ys = rows(im)
    x0 = code_x0(im)
    # gutter number of the first row is unknown; caller gives absolute numbers,
    # so take the first visible line from argv "first=N" (default: read from MANIFEST order)
    first = None
    toks = []
    for a in sys.argv[2:]:
        if a.startswith("first="):
            first = int(a[6:])
        else:
            toks.append(a)
    for t in toks:
        parts = t.split(":")
        line, col, n = int(parts[0]), int(parts[1]), int(parts[2])
        label = parts[3] if len(parts) > 3 else ""
        idx = line - first
        if idx < 0 or idx >= len(ys):
            print(f"{t}: line out of range ({len(ys)} rows)")
            continue
        y = ys[idx]
        xa, xb = int(x0 + col * CW), int(x0 + (col + n) * CW)
        px = [im.getpixel((x, yy)) for x in range(xa, xb) for yy in range(y - 6, y + 7)]
        name, avg = classify(px)
        print(f"{label or t:28s} -> {name:18s} core={avg}")


if __name__ == "__main__":
    main()
