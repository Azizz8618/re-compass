#!/usr/bin/env python3
"""GOST 10859 homoglyph canonicalisation.

The input tables are taken verbatim from dispak/dispak/encoding.c so the
normalisation is exactly the one the dispak input path applies: every Latin
or Cyrillic homoglyph maps to the same six-bit code, and we render that code
with the canonical Cyrillic glyph.  This makes token matching reliable while
preserving the byte sequence fed to the compiler.
"""
import re
from functools import lru_cache
from pathlib import Path

ENC = Path('/home/azizz/Yandex.Disk/dispak/dispak/encoding.c')
TEXT = ENC.read_text(encoding='utf-8')


def _num(x):
    if x.lower().startswith('0x'):
        return int(x, 16)
    if len(x) > 1 and x.startswith('0'):
        return int(x, 8)
    return int(x, 10)


def _array(name):
    m = re.search(r'static const unsigned short ' + name + r'\s*\[256\]\s*=\s*\{(.*?)\};',
                  TEXT, re.S)
    if not m:
        raise RuntimeError('array not found: ' + name)
    clean = re.sub(r'/\*.*?\*/', '', m.group(1), flags=re.S)
    clean = clean.replace("'\\\\'", '0x5c')
    vals = [_num(x) for x in re.findall(r'0x[0-9a-fA-F]+|\b\d+\b', clean)]
    assert len(vals) == 128, (name, len(vals))
    return vals


LAT = _array('gost_to_unicode_lat')
CYR = _array('gost_to_unicode_cyr')


def _unicode_to_gost_maps():
    start = TEXT.index('unicode_to_gost (unsigned short val)')
    end = TEXT.index('gost_to_unicode (unsigned char ch)', start)
    body = TEXT[start:end]
    tab0_src = re.sub(
        r'/\*.*?\*/', '',
        re.search(r'static const unsigned char tab0\s*\[256\]\s*=\s*\{(.*?)\};',
                  body, re.S).group(1), flags=re.S)
    tab0 = [_num(x) for x in re.findall(r'0x[0-9a-fA-F]+|\b\d+\b', tab0_src)]
    assert len(tab0) == 256
    direct = {}
    # Nested switches use the low byte of the Unicode code point.
    for hi, block in re.findall(
            r'case (0x[0-9a-fA-F]+):\s*switch [^{]*\{\s*(.*?)\n\s*\}', body, re.S):
        high = _num(hi) << 8
        for num, code in re.findall(r'case (0x[0-9a-fA-F]+|\d+):\s*return (0\d+);', block):
            direct[high | _num(num)] = _num(code)
    return tab0, direct


TAB0, DIRECT = _unicode_to_gost_maps()


@lru_cache(maxsize=None)
def gost_code(ch):
    u = ord(ch)
    if u < 256:
        return TAB0[u]
    if u in DIRECT:
        return DIRECT[u]
    return 0o17  # blank / unrepresentable


CANON = {}
for _u in list(range(0x20, 0x7f)) + list(range(0x410, 0x450)):
    _ch = chr(_u)
    _g = gost_code(_ch)
    if _g and _g != 0o17:
        CANON[_ch] = chr(CYR[_g]) if CYR[_g] else _ch
# A few symbols are representable but have no Cyrillic glyph; keep them.
for _u in (0x2260, 0x21, 0x22, 0x2a, 0x2b, 0x2d, 0x2f, 0x3a, 0x3b, 0x3c,
           0x3d, 0x3e, 0x40, 0x5b, 0x5d, 0x5f, 0x7c, 0x203e):
    _ch = chr(_u)
    if _ch not in CANON and gost_code(_ch):
        CANON[_ch] = _ch


def canon(s):
    """Return the string in canonical (Cyrillic-rendered) GOST spelling."""
    return ''.join(CANON.get(ch, ch) for ch in s)


def gostbytes(s):
    return bytes(gost_code(ch) for ch in s)


if __name__ == '__main__':
    for sample in ('BEGIN', 'ВЕGIN', 'WHILE', 'WНILЕ', 'SУSТЕМ', 'SYSTEM',
                   'РUТТ', 'PUTT', 'ЕLSЕ', 'ELSE', 'UNТIL', 'UNTIL'):
        print('%-12s -> %-12s %s' % (sample, canon(sample),
                                     ' '.join('%03o' % b for b in gostbytes(sample))))
