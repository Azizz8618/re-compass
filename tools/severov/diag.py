#!/usr/bin/env python3
"""Parse dispak diagnostics and resolve offending identifiers to their exact
glyph spelling as printed in the compiler listing.

The caret line carries digit markers whose column (0-based, in the printed
line) is the exclusive end offset of each offending token.  Extracting the
token from the listing preserves the exact 6-bit codes.
"""
import re
import sys
from collections import Counter
from pathlib import Path

DIAG = re.compile(r'^\s*\*{4,}(\d{1,3})\s+(.*)$')
SRC = re.compile(r'^\s*(\d{4,6})\s+(\d{1,4})\s+(\d)\s+(.*)$')
MARK = re.compile(r'[0-9]')
IDENT = re.compile(r'[A-Za-zА-Яа-яЁё][A-Za-zА-Яа-яЁё0-9_]*')


def token_at(src, end):
    """Identifier ending exactly at `end` (exclusive) inside `src`."""
    if end <= 0 or end > len(src):
        return ''
    m = None
    for m2 in IDENT.finditer(src[:end]):
        if m2.end() == end:
            m = m2
    return m.group(0) if m else src[max(0, end - 6):end]


def main():
    log = Path(sys.argv[1])
    lines = log.read_text(encoding='utf-8', errors='replace').splitlines()
    rows = []
    i = 0
    while i < len(lines):
        m = DIAG.match(lines[i])
        if not m:
            i += 1
            continue
        code, text = m.group(1), m.group(2).strip()
        lineno = None
        src = None
        prefix = None
        for j in range(i + 1, min(len(lines), i + 7)):
            sm = SRC.match(lines[j])
            if sm:
                lineno = int(sm.group(2))
                src = sm.group(4)
                prefix = len(lines[j]) - len(src)
                continue
            if src is not None and lines[j].strip() and not lines[j].lstrip().startswith('******'):
                marks = [mm.start() for mm in MARK.finditer(lines[j])]
                if marks and all(mm > prefix for mm in marks):
                    toks = [token_at(src, mm - prefix + 1) for mm in marks]
                    rows.append((code, lineno, toks, text, src))
                    break
            if lines[j].lstrip().startswith('******') and src is not None:
                rows.append((code, lineno, [], text, src))
                break
            if lines[j].lstrip().startswith('******'):
                break
        i += 1
    counts = Counter(r[0] for r in rows)
    print('DIAGS', len(rows), ' '.join('%s:%d' % x for x in sorted(counts.items())))
    for code, lineno, toks, text, src in rows:
        print('[%s] line=%-4s tok=%-20s %-52s | %s' % (
            code, lineno, ','.join(toks) or '-', text[:52], (src or '')[:90]))
    c = Counter(t for r in rows if r[0] == '11' for t in r[2])
    print('UNDEFINED TOKENS:')
    for t, n in c.most_common():
        print('%4d %s' % (n, t))


if __name__ == '__main__':
    main()
