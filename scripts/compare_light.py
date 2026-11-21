#!/usr/bin/env python3
"""Compare tanuki-<style> token colors with GitLab screenshots, token by token.

usage: compare_light.py SHOTS_DIR STYLE PARSER_RTP CACHE_DIR [shot-prefix ...]
Reads SHOTS_DIR/MANIFEST.md (filename | URL | lines), downloads each file (raw),
renders the same lines with scripts/tokens.lua, classifies each token's color in
the screenshot with scripts/tok.py, and prints the agreement per language and the
disagreements grouped by capture.

Screenshots of GitLab UI states (blame view, selected text, highlighted #L lines) change the
background, so they're reported separately and left out of the syntax agreement.
"""
import collections, json, os, re, subprocess, sys, urllib.request
from PIL import Image

sys.path.insert(0, os.path.dirname(__file__))
import tok  # noqa: E402

UI_SHOTS = {"blame", "line-highlight", "selection"}

ROLE = {  # tanuki-day fg -> role
    "#3a383d": "fg", "#555555": "fg", "#999988": "grey", "#999999": "grey", "#dd1144": "string",
    "#990000": "func", "#aa0000": "func", "#445588": "type", "#0086b3": "builtin", "#008080": "teal",
    "#009999": "teal", "#990073": "symbol", "#009926": "regex", "#800080": "heading", "#000080": "tag",
}


def shot_role(name):
    if name is None:
        return None
    for key, role in (("fg", "fg"), ("grey", "grey"), ("string", "string"), ("func", "func"), ("quote", "func"),
                      ("type", "type"), ("builtin", "builtin"), ("teal", "teal"), ("symbol", "symbol"),
                      ("regex", "regex"), ("heading", "heading"), ("tag", "tag"), ("ns", "fg")):
        if name.startswith(key):
            return role
    return name


def manifest(d):
    rows = []
    for line in open(os.path.join(d, "MANIFEST.md")):
        m = re.match(r"\|\s*([\w.-]+\.png)\s*\|\s*(https?://\S+)\s*\|\s*(\d+)\s*[–-]\s*(\d+)\s*\|", line)
        if m:
            rows.append((m.group(1), m.group(2), int(m.group(3)), int(m.group(4))))
    return rows


def fetch(url, cache):
    raw = url.split("?")[0].replace("/-/blob/", "/-/raw/")
    name = re.sub(r"[^\w.]+", "_", raw.split("://", 1)[1])
    path = os.path.join(cache, name)
    if not os.path.exists(path):
        urllib.request.urlretrieve(raw, path)
    # keep the real file name for filetype detection
    real = os.path.join(cache, "named", name.replace(".", "_") , os.path.basename(raw))
    os.makedirs(os.path.dirname(real), exist_ok=True)
    if not os.path.exists(real):
        os.link(path, real)
    return real


def calibrate(im, x0, ys, lines, first):
    g = im.convert("L")
    w = im.size[0]
    est = []
    for i, y in enumerate(ys):
        n = first + i
        if n - 1 >= len(lines):
            break
        text = lines[n - 1].rstrip("\n").expandtabs(8).rstrip()
        if len(text) < 20 or x0 + len(text) * 8 > w - 10:
            continue
        xr = max((x for x in range(x0, w) for yy in (y - 3, y, y + 3) if g.getpixel((x, yy)) < 200), default=None)
        if xr:
            est.append((xr - x0 + 1) / len(text))
    est.sort()
    return est[len(est) // 2] if est else tok.CW


def main():
    shots_dir, style, rtp, cache = sys.argv[1:5]
    only = sys.argv[5:]
    agg = collections.defaultdict(lambda: [0, []])
    total = agree = 0
    per_lang = collections.defaultdict(lambda: [0, 0])  # lang -> [agree, total]
    for fname, url, first, last in manifest(shots_dir):
        if only and not any(fname.startswith(p) for p in only):
            continue
        src = fetch(url, cache)
        out = subprocess.run(["nvim", "--headless", "-u", "NONE", "-l", "scripts/tokens.lua", src, str(first), str(last), style, rtp],
                             capture_output=True, text=True).stdout
        runs = [json.loads(l) for l in out.splitlines() if l.startswith("{")]
        im = Image.open(os.path.join(shots_dir, fname)).convert("RGB")
        ys, x0 = tok.rows(im), tok.code_x0(im)
        lines = open(src, encoding="utf-8", errors="replace").readlines()
        cw = calibrate(im, x0, ys, lines, first)
        lang = fname.rsplit("-", 1)[0]
        for r in runs:
            if not re.search(r"\w", r["text"]):
                continue
            idx = r["line"] - first
            if idx >= len(ys):
                continue
            xa, xb = int(x0 + r["col"] * cw), int(x0 + (r["col"] + r["len"]) * cw)
            if xb > im.size[0] - 4:
                continue
            y = ys[idx]
            px = [im.getpixel((x, yy)) for x in range(xa, xb) for yy in range(y - 6, y + 7)]
            seen = shot_role(tok.classify(px)[0])
            want = ROLE.get(r["fg"], r["fg"])
            if seen is None:
                continue
            total += 1
            per_lang[lang][1] += 1
            if seen == want:
                agree += 1
                per_lang[lang][0] += 1
            else:
                key = (lang, r["name"], want, seen)
                agg[key][0] += 1
                if len(agg[key][1]) < 4:
                    agg[key][1].append(f'{r["text"]}@{r["line"]}')
    syn = [v for k, v in per_lang.items() if k not in UI_SHOTS]
    syn_agree, syn_total = sum(a for a, _ in syn), sum(t for _, t in syn)
    print(f"syntax agreement: {syn_agree}/{syn_total} = {100 * syn_agree / max(1, syn_total):.1f}%")
    print(f"all screenshots:  {agree}/{total} = {100 * agree / max(1, total):.1f}%\n")
    for lang, (a, t) in sorted(per_lang.items(), key=lambda kv: (kv[0] in UI_SHOTS, kv[0])):
        note = "  (UI state)" if lang in UI_SHOTS else ""
        print(f"  {lang:15s} {a:5d}/{t:<5d} {100 * a / max(1, t):5.1f}%{note}")
    print()
    for (lang, name, want, seen), (n, ex) in sorted(agg.items(), key=lambda kv: (kv[0][0], -kv[1][0])):
        if n >= 2:
            print(f"{lang:11s} {name:32s} ours={want:8s} gitlab={seen:8s} x{n:<3d} {' '.join(ex)}")


if __name__ == "__main__":
    main()
