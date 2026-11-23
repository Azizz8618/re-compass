#!/usr/bin/env python3
"""Build a front-end deck that feeds the ORIGINAL gold deck as INPUT.

The Pascal front-end is the repository SERVIS processor with one small
addition: a SysCard() filter in the main read loop.  The SERVIS operators
are not touched; they come verbatim from the gold file lines 1-41.
"""
import pathlib

BASE = pathlib.Path(__file__).resolve().parents[2]
REPO = BASE
GOLD = REPO / 'gold/BESM-6 (Pavel Severov, NIS GIDROPROEKT) KOMPAS-based systems 1988-1989.txt'
TEMPLATE = REPO / 'tests/gold_servis.b6'

src = (REPO / 'src/servis.pas').read_text(encoding='utf-8')

filter_fn = '''(* Front-end: the original gold deck is read as INPUT verbatim.
   Recognise the monitor/system cards and their head lines, skip them,
   and pass every subsequent line to the SERVIS processor unchanged. *)
function SysCard: boolean;
var q: integer;
begin
  q := 1;
  while (q <= 72) and (ln[q] = ' ') do q := q + 1;
  SysCard := false;
  if q <= 72 then
    SysCard := (ln[q] = '?') or (ln[q] = '*') or
      ((ln[q] = 'Ш') and (ln[q+1] = 'И') and (ln[q+2] = 'Ф')) or
      ((ln[q] = 'O') and (ln[q+1] = 'З') and (ln[q+2] = 'Y')) or
      ((ln[q] = 'E') and (ln[q+1] = 'E') and (ln[q+2] = 'B'))
end;

'''
assert 'procedure Init;\n' in src
src = src.replace('procedure Init;\n', filter_fn + 'procedure Init;\n', 1)
# Stop after the single KOHEЦ. operator: the input queue wraps at EOF.
assert '  nxt: char;\n' in src
src = src.replace('  nxt: char;\n', '  nxt: char;\n  done: boolean;\n', 1)

old_loop = '''  while not eof(input) do begin
    readln(ln);
    p := 1;
    repeat
      Stmt;
      Skip;
      if p <= 72 then begin
        nxt := ln[p];
        if (nxt = ';') or (nxt = ',') then p := p + 1
        else p := 73
      end
    until p > 72
  end;
'''
new_loop = '''  done := false;
  while not eof(input) and not done do begin
    readln(ln);
    if SysCard then
      writeln('FRONT: SYSTEM CARD SKIPPED: ', ln)
    else begin
      p := 1;
      repeat
        Stmt;
        Skip;
        if p <= 72 then begin
          nxt := ln[p];
          if (nxt = ';') or (nxt = ',') then p := p + 1
          else p := 73
        end
      until p > 72;
      p := 1;
      while (p <= 72) and (ln[p] = ' ') do p := p + 1;
      if p <= 72 then
        if ln[p] = 'К' then done := true
    end
  end;
'''
assert old_loop in src
src = src.replace(old_loop, new_loop, 1)
(BASE / 'src/servis_front.pas').write_text(src, encoding='utf-8')

tpl = TEMPLATE.read_text(encoding='utf-8').splitlines()
i0 = next(i for i, l in enumerate(tpl) if l.startswith('(*=y+,s0,s7*)program servis'))
i1 = next(i for i, l in enumerate(tpl) if l.strip().lower() == '*execute')
gold = GOLD.read_text(encoding='utf-8').splitlines()[:41]
# The gold deck is embedded verbatim after *execute; only the job wrapper
# (passport, LUNs, compiler call and final EOF marker) comes from the template.
deck = tpl[:i0] + src.rstrip('\n').splitlines() + ['*execute'] + gold + tpl[i1+1:]
(BASE / 'tests/original_deck_front.b6').write_text('\n'.join(deck) + '\n', encoding='utf-8')
# Transport variant: one leading blank in column 1 keeps the monitor's card
# reader from interpreting the original system cards; operator text is intact.
pad = [' ' + l for l in gold]
deck_pad = tpl[:i0] + src.rstrip('\n').splitlines() + ['*execute'] + pad + tpl[i1+1:]
(BASE / 'tests/original_deck_front_pad.b6').write_text('\n'.join(deck_pad) + '\n', encoding='utf-8')
print('source lines', len(src.splitlines()), 'deck lines', len(deck),
      'gold lines embedded', len(gold))
