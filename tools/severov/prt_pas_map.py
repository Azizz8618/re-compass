#!/usr/bin/env python3
"""Align TSSPPR.PRT (macros &&...&&) with TSSPPR.PAS (expanded TPCMP calls).

Read-only study of the original listing.  Produces a macro -> call-sequence
table under map/ so the W5a adapter can later be checked against the
historical translation performed by the original preprocessor.
"""
import difflib
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
PRT = REPO / 'gold/TSSPPR.PRT'
PAS = REPO / 'gold/TSSPPR.PAS'
OUT = REPO / 'docs/severov-apps'
PAIR = re.compile(r'&&.*?&&', re.S)
CALL = re.compile(r'\b(TPCMP\w+)\s*(?:\(\s*([^)]*)\s*\))?')


def norm(s):
    return re.sub(r'\s+', ' ', s).strip()


def prt_blocks():
    raw = PRT.read_bytes().decode('cp866').replace('\r', '').split('\n')
    joined = '\n'.join(raw)
    blocks, lines = [], []
    last = 0
    for m in PAIR.finditer(joined):
        pre = joined[last:m.start()]
        block_lines = pre.split('\n')
        for i, line in enumerate(block_lines[:-1]):
            lines.append((len(lines) + 1, line, None))
        last_line = block_lines[-1]
        lines.append((len(lines) + 1, last_line, len(blocks)))
        blocks.append({
            'id': len(blocks) + 1,
            'text': m.group(0)[2:-2].replace('\n', ' ').strip(),
            'prt_first_line': joined[:m.start()].count('\n') + 1,
            'prt_last_line': joined[:m.end()].count('\n') + 1,
        })
        # remember the macro tail on the same line as the closing &&
        blocks[-1]['head'] = last_line.split('&&')[0]
        last = m.end()
    for line in joined[last:].split('\n'):
        lines.append((len(lines) + 1, line, None))
    return blocks, lines


def pas_blocks():
    raw = PAS.read_bytes().decode('cp866').replace('\r', '').split('\n')
    lines, blocks = [], []
    i = 0
    while i < len(raw):
        line = raw[i]
        if re.match(r'\s*BEGIN\s+TPCMP', line):
            group = [line]
            j = i + 1
            while j < len(raw) and not re.match(r'\s*END\s*;', raw[j]):
                group.append(raw[j])
                j += 1
            if j < len(raw):
                group.append(raw[j])
            calls = []
            for g in group:
                for m in CALL.finditer(g):
                    calls.append('%s(%s)' % (m.group(1), norm(m.group(2) or '')))
            lines.append((len(lines) + 1, '@@CALL@@', len(blocks)))
            blocks.append({
                'id': len(blocks) + 1,
                'pas_first_line': i + 1,
                'pas_last_line': j + 1,
                'calls': calls,
            })
            i = j + 1
            while i < len(raw) and not raw[i].strip():
                i += 1
            continue
        lines.append((len(lines) + 1, line, None))
        i += 1
    return blocks, lines


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    pblks, plines = prt_blocks()
    cblks, clines = pas_blocks()
    pm = [norm(x[1]) if x[2] is None else '@@CALL@@' for x in plines]
    cm = [norm(x[1]) for x in clines]
    sm = difflib.SequenceMatcher(None, pm, cm, autojunk=False)
    pairs = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal':
            continue
        for a, b in zip(range(i1, i2), range(j1, j2)):
            pb, cb = plines[a][2], clines[b][2]
            if pb is not None and cb is not None:
                pairs.append((pblks[pb], cblks[cb]))

    total_calls = {}
    for _p, c in pairs:
        for call in c['calls']:
            name = call.split('(')[0]
            total_calls[name] = total_calls.get(name, 0) + 1

    out = {
        'prt': str(PRT), 'pas': str(PAS),
        'prt_encoding': 'cp866',
        'prt_macros': len(pblks), 'pas_expansions': len(cblks),
        'aligned_pairs': len(pairs),
        'calls_by_name': total_calls,
        'pairs': [
            {
                'macro_id': p['id'],
                'macro': p['text'],
                'prt_lines': [p['prt_first_line'], p['prt_last_line']],
                'pas_lines': [c['pas_first_line'], c['pas_last_line']],
                'calls': c['calls'],
            }
            for p, c in pairs
        ],
    }
    (OUT / 'prt-pas-macro-calls.json').write_text(
        json.dumps(out, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    md = ['# TSSPPR.PRT -> TSSPPR.PAS: macro -> call sequence', '',
          'PRT: %d macros, PAS: %d expansions, aligned: %d.'
          % (len(pblks), len(cblks), len(pairs)), '',
          'Calls by name: %s' % json.dumps(total_calls, sort_keys=True), '',
          'W4 reference (analysis.txt): TPCMPP1=243, TPCMPIN1=47, '
          'TPCMPAD1=31, TPCMPL1=5.', '',
          '| # | PRT lines | PAS lines | macro (cp866) | TPCMP sequence |',
          '|---:|---|---|---|---|']
    for i, (p, c) in enumerate(pairs, 1):
        macro = p['text'].replace('|', '!').replace('`', "'")
        if len(macro) > 90:
            macro = macro[:87] + '...'
        calls = ', '.join(c['calls'])
        if len(calls) > 200:
            calls = calls[:197] + '...'
        md.append('| %d | %d-%d | %d-%d | `%s` | `%s` |'
                  % (i, p['prt_first_line'], p['prt_last_line'],
                     c['pas_first_line'], c['pas_last_line'], macro, calls))
    (OUT / 'prt-pas-macro-calls.md').write_text('\n'.join(md) + '\n',
                                                  encoding='utf-8')
    print('PRT macros', len(pblks), 'PAS expansions', len(cblks),
          'aligned', len(pairs))
    print('calls', json.dumps(total_calls, sort_keys=True))


if __name__ == '__main__':
    main()
