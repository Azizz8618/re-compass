#!/usr/bin/env python3
"""W5a preparation: slice the 18 Severov Pascal programs out of the gold
listing, turn every ``&& ... &&`` snippet into DMLCALL(n), and emit dispak
decks that connect the future TSS PERSO libraries.

Nothing in this tool writes to the repository.  All output is relative to
the directory given by --out (default: current directory).
"""

import argparse
import hashlib
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
GOLD = REPO / ('gold/BESM-6 (Pavel Severov, NIS GIDROPROEKT) '
               'KOMPAS-based systems 1988-1989.txt')

# docs/TSS-CHAIN.md section 5.2.  SKLMON additionally owns gold line 1122,
# the HEAD body "BEGIN &&...&& END." that sits two lines above its PROGRAM
# header; without it decks 12-14 contain 344 pairs instead of the 345
# recorded in docs/TSS-PORT-PLAN.md section 1.
PROGRAMS = [
    ('SKLMON', 1124, 1370, 'deck12-skmon.out', [1122]),
    ('AMOHED', 2307, 2312, 'deck13-amhed.out', []),
    ('ZATHED', 3565, 3570, 'deck14-zathed.out', []),
    ('SKLOTD', 1371, 1482, 'deck12-skl-otd.out', []),
    ('SKLCAR', 1483, 1876, 'deck12-skl-car.out', []),
    ('SKLOTC', 1877, 2306, 'deck12-skl-otc.out', []),
    ('AMOMON', 2313, 2522, 'deck13-ammon.out', []),
    ('AMOOTD', 2523, 2631, 'deck13-amo-otd.out', []),
    ('AMOCAR', 2632, 3044, 'deck13-amo-car.out', []),
    ('AMOOTC', 3045, 3407, 'deck13-amo-otc.out', []),
    ('AMOGRU', 3408, 3564, 'deck13-amgru.out', []),
    ('ZATMON', 3571, 3830, 'deck14-zatmon.out', []),
    ('ZATOTD', 3831, 3963, 'deck14-zat-otd.out', []),
    ('ZATCOF', 3964, 4117, 'deck14-zatcof.out', []),
    ('ZATZAT', 4118, 4379, 'deck14-zatzat.out', []),
    ('ZATNAK', 4380, 4564, 'deck14-zatnak.out', []),
    ('ZATRTE', 4565, 4790, 'deck14-zatrte.out', []),
    ('ZATTAB', 4791, 5392, 'deck14-zattab.out', []),
]

# Reserved PERSO zones, all inside the free 3250..3334 range of
# docs/ZONE-ALLOCATION.md.  2560 (GOSTLIB) and 3360 (old TSSPPR probe)
# are deliberately left alone.
ZONE_TSSDML = 0o3260
ZONE_TSSPPR = 0o3300
ZONE_MADX = 0o3370

DECK_HEADER = [
    'шифр 419999зс5^',
    'лен 40(2348-630)^',
    'лен 41(2348)^',
    'ОЗУ 32^',
    'ее в1а3',
    '*name ',
    '*call yesmemory',
    '*perso:412570',        # COMTUP + SERVIS + Pascal runtime, zone 2570 on LU 41
    '*perso:413350,cont',   # UCOMPAS, zone 3350
    '*perso:41%04o,cont' % ZONE_TSSDML,
    '*perso:41%04o,cont' % ZONE_TSSPPR,
    '*perso:41%04o,cont' % ZONE_MADX,
    '*stand',
    '*call *pascal',
]

INLINE_MADX = (Path(__file__).resolve().parents[1] / 'src' / 'madx_inline.pas')\
    .read_text(encoding='utf-8').splitlines()

PRELUDE = [
    'type',
    '  alfa = packed array[1..6] of char;',
    '  word = record case integer of',
    '    0:(i:integer); 1:(a:alfa); 2:(c:char) end;',
    '  TBDVec = array[0..167] of word;',
    '  TYPEM = packed array[1..160] of char;',
    '  ZZBUFT = record LEN,H,D,I:integer; M:TYPEM end;',
    'var',
    '  BDVECT: TBDVec;',
    '  BDERRN: integer;',
    '  BUF: ZZBUFT;',
    '  C: char;',
    *INLINE_MADX,
]

PAIR_RE = re.compile(r'&&.*?&&', re.S)


def gold_lines():
    """Read the gold text with the same decoding as tools/severov/extract_gold.py."""
    text = GOLD.read_text(encoding='utf-8-sig').splitlines()
    return [x.rstrip('\r') for x in text]


def program_line_numbers(spec):
    """Lines scanned for DMLCALL snippets (includes the SKLMON HEAD body)."""
    _name, start, end, _out, extra = spec
    return sorted(set(extra) | set(range(start, end + 1)))


def body_line_numbers(spec):
    """Lines copied into the .pas source: only the documented PROGRAM range."""
    _name, start, end, _out, _extra = spec
    return list(range(start, end + 1))


def collect_snippets(lines):
    """Number every &&...&& pair in gold order across all 18 programs."""
    ordered = []
    for spec in PROGRAMS:
        for ln in program_line_numbers(spec):
            ordered.append((spec[0], ln, lines[ln - 1]))

    joined = '\n'.join(rec[2] for rec in ordered)
    offsets = []
    pos = 0
    for rec in ordered:
        offsets.append(pos)
        pos += len(rec[2]) + 1

    def line_at(offset):
        lo, hi, guess = 0, len(offsets) - 1, 0
        while lo <= hi:
            mid = (lo + hi) // 2
            if offsets[mid] <= offset:
                guess = mid
                lo = mid + 1
            else:
                hi = mid - 1
        return ordered[guess][0], ordered[guess][1]

    snippets = []
    for num, match in enumerate(PAIR_RE.finditer(joined), 1):
        name, ln = line_at(match.start())
        raw = match.group(0)[2:-2]
        snippets.append({
            'id': num,
            'program': name,
            'gold_line': ln,
            'text': raw,
            'in_directive': '(*=L' in joined[max(0, match.start() - 24):match.start()],
        })
    return ordered, joined, snippets


def strip_underscores(line):
    """Drop '_' outside quoted literals: gold uses THEN_/DO_/EXIT_ macro
    tokens which 15.1 cannot lex, but 'CONST EE='_'' must stay intact."""
    out = []
    quoted = False
    for ch in line:
        if ch == "'":
            quoted = not quoted
        if ch != '_' or quoted:
            out.append(ch)
    return ''.join(out)


def comment_editor_lines(line):
    """The gold listing contains *EDIT / !INCLU / ? .XXX *) cards that
    belonged to the original editor session, not to the Pascal source."""
    s = line.strip()
    if s.startswith('!INCLU:'):
        return '(* EDITOR ' + s.replace('*', '') + '*)'
    if s.startswith('?.'):
        return '(* SECTION ' + s.replace('*)', '').strip() + ' *)'
    if s.startswith('?'):
        return '(* SECTION ' + s.replace('*)', '').strip() + ' *)'
    if s.startswith('*'):
        return '(* DECK ' + s.replace('*', '') + ' *)'
    return line


def brace_comments(line):
    """15.1 does not treat {...} as a comment; none occur in decks 12-14,
    but the front-end performs the conversion for completeness."""
    return line.replace('{', '(*').replace('}', '*)')


def wrap_line(line, limit=70):
    """Split over-long cards at the last safe blank outside a literal."""
    if len(line.encode('utf-8')) <= limit:
        return [line]
    out, rest = [], line
    while len(rest.encode('utf-8')) > limit:
        quoted = False
        cut = -1
        for i, ch in enumerate(rest):
            if ch == "'":
                quoted = not quoted
            elif ch in ' ;,' and not quoted and i > 0:
                cut = i
            if i >= 90:
                break
        if cut < 1:
            break
        head, rest = rest[:cut], rest[cut + 1:].lstrip()
        out.append(head)
    out.append(rest)
    return out


def byte_len(line):
    return len(line.encode('utf-8'))


def build_source(name, body_lines, snippets):
    """Prepend the 15.1 prelude and a generated DmlCall dispatcher."""
    ids = [s['id'] for s in snippets]
    head = ['(*=y+,s0,s7*)']
    # Keep the original PROGRAM header (with its (*=L1*) directive) first.
    if not body_lines:
        raise RuntimeError('empty body for ' + name)
    head.append(body_lines[0])

    dml = []
    dml.extend(PRELUDE)
    dml.append('procedure DmlCall(N:integer);')
    dml.append('var J:integer;')
    dml.append('begin')
    dml.append('  for J:=1 to 160 do BUF.M[J]:=\' \';')
    dml.append('  case N of')
    for s in snippets:
        text = s['text'].replace('\n', ' ').strip()
        chars = [(i + 1, ch) for i, ch in enumerate(text) if ch != '\n']
        dml.append('    %d: begin' % s['id'])
        dml.append('      BUF.LEN:=%d;' % len(text))
        # Four char assignments per line keeps every card under 72 bytes.
        for k in range(0, len(chars), 4):
            chunk = chars[k:k + 4]
            parts = ["BUF.M[%d]:='%s';" % (idx, ch) for idx, ch in chunk]
            # A quote inside a literal is doubled for Pascal.
            parts = [p.replace("':=''", "':=''") for p in parts]
            dml.append('      ' + ''.join(parts))
        dml.append('      BUF.M[BUF.LEN+1]:=chr(255)')
        dml.append('    end;')
    dml.append('  end;')
    dml.append('  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=\' \';')
    dml.append('  QMADX(0)')
    dml.append('end;')

    # Program parameters are the Pascal-Monitor common area: BUF must be
    # declared in both the caller and the MADX PERSO module.
    head[1] = re.sub(
        r'(?i)(\bPROGRAM\s+)([A-Za-z][A-Za-z0-9]*)',
        r'\1\2(output,BUF,BDVECT,BDERRN);', head[1], count=1)
    prelude = head + dml
    # The original HEAD body for SKLMON is kept as an ordinary procedure so
    # that its DMLCALL is syntactically live rather than buried in a comment.
    if name == 'SKLMON':
        head_snippet = next(s for s in snippets if s['gold_line'] == 1122)
        prelude += ['(* HEAD block of deck 12, gold line 1122 *)',
                    'procedure SKLHEAD;',
                    'begin DMLCALL(%d) end;' % head_snippet['id']]
        ids = [i for i in ids if i != head_snippet['id']]

    tail = body_lines[1:]
    source = prelude + tail
    # A '(*=L0 ...*)' card ends the compiler's source listing: the remaining
    # Pascal main block would never be compiled.  Make it an ordinary card.
    source = [x.replace('(*=L0 ', '(* L0 ') for x in source]
    # Cards left after the final END. are fed to the next (Fortran) compiler
    # by the monitor.  The last END. must be the final Pascal card.
    ends = [i for i, x in enumerate(source) if 'END.' in x.upper()]
    if not ends:
        raise RuntimeError('no final END. for ' + name)
    return source[:ends[-1] + 1], ids


def build_deck(name, source_lines, warnings):
    deck = list(DECK_HEADER)
    for line in source_lines:
        deck.extend(wrap_line(line))
    deck += ['*execute', '*end file', '``````', 'еконец']
    over = [(i + 1, byte_len(x)) for i, x in enumerate(deck) if byte_len(x) > 72]
    if over:
        warnings.append('%s: %d cards still >72 bytes: %s'
                        % (name, len(over), over[:5]))
    return deck


def main():
    global GOLD
    ap = argparse.ArgumentParser()
    ap.add_argument('--gold', type=Path, default=GOLD)
    ap.add_argument('--out', type=Path, default=Path.cwd())
    args = ap.parse_args()

    GOLD = args.gold
    out = args.out
    for sub in ('src', 'decks', 'map', 'artifacts'):
        (out / sub).mkdir(parents=True, exist_ok=True)

    lines = gold_lines()
    _ordered, _joined, snippets = collect_snippets(lines)
    warnings = []
    report = {}
    json_map = {
        'source': str(GOLD),
        'total_pairs': len(snippets),
        'zones': {
            'COMTUP_SERVIS': '2570 (perso:412570)',
            'UCOMPAS': '3350 (perso:413350,cont)',
            'TSSDML': '%04o (perso:41%04o,cont)' % (ZONE_TSSDML, ZONE_TSSDML),
            'TSSPPR': '%04o (perso:41%04o,cont)' % (ZONE_TSSPPR, ZONE_TSSPPR),
            'MADX': '%04o (perso:41%04o,cont)' % (ZONE_MADX, ZONE_MADX),
        },
        'programs': {},
    }

    for spec in PROGRAMS:
        name = spec[0]
        body_text = '\n'.join(lines[n - 1] for n in body_line_numbers(spec))
        snips = [s for s in snippets if s['program'] == name]
        # The SKLMON HEAD pair lives on gold line 1122 and is emitted as
        # procedure SKLHEAD; it is not part of the sliced PROGRAM text.
        body_snips = [s for s in snips if s['gold_line'] != 1122]

        pieces, last = [], 0
        for idx, m in enumerate(PAIR_RE.finditer(body_text)):
            pieces.append(body_text[last:m.start()])
            pieces.append('DMLCALL(%d)' % body_snips[idx]['id'])
            last = m.end()
        pieces.append(body_text[last:])
        replaced = ''.join(pieces)
        body = [comment_editor_lines(brace_comments(strip_underscores(x)))
                for x in replaced.split('\n')]
        source, _live_ids = build_source(name, body, snips)

        src_path = out / 'src' / (name + '.pas')
        src_path.write_text('\n'.join(source) + '\n', encoding='utf-8', newline='\n')
        deck = build_deck(name, source, warnings)
        deck_path = out / 'decks' / (name + '.b6')
        deck_path.write_text('\n'.join(deck) + '\n', encoding='utf-8', newline='\n')

        ncalls = sum(x.count('DMLCALL(') for x in source)
        report[name] = (len(snips), ncalls, len(source), len(deck))
        json_map['programs'][name] = {
            'gold_lines': ([1122] if name == 'SKLMON' else []) +
                          list(range(spec[1], spec[2] + 1)),
            'etalon': spec[3],
            'pair_count': len(snips),
            'dmlcall_tokens': ncalls,
            'snippets': [
                {'id': s['id'], 'gold_line': s['gold_line'],
                 'in_directive': s['in_directive'], 'text': s['text']}
                for s in snips
            ],
        }

    (out / 'map' / 'snippet-map.json').write_text(
        json.dumps(json_map, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    md = ['# PROGRAM -> DMLCALL -> gold snippet map', '',
          'Всего пар: %d.' % len(snippets), '',
          '| PROGRAM | server | DMLCALL | gold line | snippet |',
          '|---|---:|---:|---:|---|']
    for spec in PROGRAMS:
        name = spec[0]
        for s in [x for x in snippets if x['program'] == name]:
            txt = s['text'].replace('\n', ' ').replace('|', '!').strip()
            if len(txt) > 70:
                txt = txt[:67] + '...'
            md.append('| %s | %s | %d | %d | `%s` |'
                      % (name, 'directive' if s['in_directive'] else 'code',
                         s['id'], s['gold_line'], txt))
    (out / 'map' / 'snippet-map.md').write_text('\n'.join(md) + '\n', encoding='utf-8')

    lines_out = ['program pairs dmlcall_tokens source_lines deck_lines']
    total_pairs = total_calls = 0
    for name, (p, c, sl, dl) in report.items():
        lines_out.append('%-8s %5d %5d %5d %5d' % (name, p, c, sl, dl))
        total_pairs += p
        total_calls += c
    lines_out.append('TOTAL    %5d %5d' % (total_pairs, total_calls))
    lines_out += ['', 'WARNINGS:'] + (warnings or ['none'])
    (out / 'artifacts' / 'counts.txt').write_text('\n'.join(lines_out) + '\n',
                                                  encoding='utf-8')
    print('\n'.join(lines_out))
    if total_pairs != 345 or total_calls != 345:
        raise SystemExit('count mismatch: expected 345 pairs and 345 DMLCALLs')


if __name__ == '__main__':
    main()
