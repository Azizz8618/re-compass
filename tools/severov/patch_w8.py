#!/usr/bin/env python3
"""W8: real keyed MAD lookup in the four Severov ports.

Reuses the existing inlined MAD interpreter and MARS COMTUP getd/putd path.
Only three things are added:
  1. `HAЙTИ ПO-KЛЮ <var> B <set>` is parsed as opcode 24 instead of the
     owner operation and keeps both the variable and the set name.
  2. Opcode 24 builds a six-character key from the set prefix and the
     numeric variable (MAD `Ц!`/`A!`) and calls the existing QLoadRec/getd.
  3. At program start the verified deck09 records are loaded into the same
     MARS area, so GETD has real records to find in the same process.
"""
import re
import sys
from pathlib import Path

S = Path('/home/azizz/.local/share/vifm/Trash/w8-realdata')
DECK09 = Path('/home/azizz/Yandex.Disk/re-compass/tests/deck09.b6')

SETS = {
    'ZATMON': [('SY-ПAP', 'PA'), ('ПA-AЛФ', 'P1'), ('ПA-ЦEЛ', 'P2')],
    'ZATZAT': [('SY-TEM', 'AC'), ('TE-ИCП', 'B1'), ('OT-ИCП', 'B2'),
               ('ИC-ИCП', 'B3'), ('TE-ЭTA', 'A1'), ('ЭT-ЗAT', 'A2'),
               ('ИC-ЗAT', 'A3'), ('ЗAT   ', 'A4')],
    'ZATNAK': [('SY-HAK', 'HA'), ('HAKЛ  ', 'H1')],
    'ZATRTE': [('SY-OTД', '63'), ('SY-TEM', 'AC'), ('TE-ИCП', 'B1'),
               ('OT-ИCП', 'B2'), ('ИC-ИCП', 'B3'), ('TE-ЭTA', 'A1'),
               ('ЭTAП  ', 'A2'), ('ЭT-ЗAT', 'A4')],
    'ZATTAB': [('SY-ПAP', 'PA'), ('ПA-ДEЙ', 'P1'), ('SY-HAK', 'HA'),
               ('SY-TEM', 'AC'), ('TE-ИCП', 'B1'), ('ИC-ЗAT', 'A1'),
               ('ЭT-ЗAT', 'A2'), ('OT-ИCП', 'B2')],
}


def deck09_records():
    recs, prefix = [], None
    for line in DECK09.read_text(encoding='utf-8').splitlines():
        if line.startswith('SET '):
            prefix = line.split()[2]
        elif line.startswith('D0') and len(line) >= 53:
            key = prefix + line[1:5]
            words = [line[5 + 6 * k:11 + 6 * k] for k in range(8)]
            recs.append((key, words))
    return recs


def emit_put(key, words, indent='  '):
    lines = []
    for k, w in enumerate(words, 1):
        lit = w[:6].ljust(6)
        lines.append(f"{indent}Qw.a:='{lit}'; W8V[{k}]:=Qw.i;")
    lines.append(f"{indent}QClrErr; putd('{key}',W8V);")
    return '\n'.join(lines)


def loader(name):
    recs = deck09_records()
    lines = ['procedure W8LOAD;', 'var W8IX:integer;', 'begin',
             '  W8IX:=20270001c; QClrErr; newd(\'ZGEN  \',W8IX);',
             '  pasbdi; BDERRN:=0;',
             "  QClrErr; opend('ZGEN  ');",
             "  writeln('W8-OPEN-BD36=',BDVECT[36].i,' EXN=',QEXN);"]
    # Verified records from tests/deck09.b6, loaded verbatim.
    for key, words in recs:
        lines.append(emit_put(key, words))
    # One record per set used by this program, reusing the first deck09
    # record as the payload and the set prefix from the W7 schema.
    payload = recs[0][1]
    for setname, prefix in SETS[name]:
        key = prefix + '0001'
        if key in [r[0] for r in recs]:
            continue
        lines.append(emit_put(key, payload))
    if name == 'ZATTAB':
        keys = [r[0] for r in recs] + [p + '0001' for _, p in SETS[name]]
        if 'SY0001' not in keys:
            lines.append(emit_put('SY0001', payload))
    lines.append("  writeln('W8-LOAD-EXN=',QEXN,' KEYS=',%d);" % (len(recs) + len(SETS[name])))
    # Counters used by FIND FIRST/FIND NEXT inside the MAD interpreter.
    for i, (setname, prefix) in enumerate(SETS[name], 1):
        n = sum(1 for k, _ in recs if k[:2] == prefix) or 1
        lines.append(f'  Qsm[{i}]:={n}; Qsc[{i}]:=1;')
    lines.append('  ЦX:=1;')
    lines.append('end;')
    return '\n'.join(lines)


def patch(name, src):
    # 1. External MARS initialization declarations.
    anchor = 'function QEXN:integer;'
    assert src.count(anchor) == 1, (name, 'QEXN')
    src = src.replace(anchor,
                      'procedure PASACD(var i:integer); FORTRAN;\n'
                      'procedure PASSETAR(i:integer); EXTERNAL;\n'
                      'procedure pasbdi; external;\n' + anchor, 1)

    # 2. Scratch array next to the existing MAD record buffer.
    anchor = 'Qv8:Qv8t; Qcurbuf:integer;'
    assert src.count(anchor) == 1, (name, 'Qv8')
    src = src.replace(anchor, anchor + '\n    W8V:array[1..8] of integer;', 1)

    # 3. Parse `HAЙTИ ПO-KЛЮ <arg> B <set>` as opcode 24.
    old = """    if Qtok='HAЙTИ ' then begin
      QNext;
      if Qtok='ПEPBYЮ' then Qo2[Qnm]:=1
      else if Qtok='CЛEДYЮ' then Qo2[Qnm]:=2
      else if Qtok='ПPEДЫД' then Qo2[Qnm]:=3
      else if Qtok='ПOCЛEД' then Qo2[Qnm]:=4
      else if Qtok='BЛAДEЛ' then Qo2[Qnm]:=5
      else Qo2[Qnm]:=6;
      QNext;
      if Qtok='B     ' then QNext;  (* B = 'in' before a set name. *)
      Qx1[Qnm]:=Qtok
    end else if Qtok='BЗЯTЬ ' then begin"""
    new = """    if Qtok='HAЙTИ ' then begin
      QNext;
      if (Qtok[1]='П') and (Qtok[3]='-') then begin
        (* W8-BYKEY: keep the key variable and the set name separately. *)
        Qo2[Qnm]:=24;
        QNext;
        if Qtok='B     ' then begin
          Qx1[Qnm]:='      '; QNext
        end else begin
          Qx1[Qnm]:=Qtok; QNext;
          if Qtok='B     ' then QNext
        end;
        Qx2[Qnm]:=Qtok
      end else begin
        if Qtok='ПEPBYЮ' then Qo2[Qnm]:=1
        else if Qtok='CЛEДYЮ' then Qo2[Qnm]:=2
        else if Qtok='ПPEДЫД' then Qo2[Qnm]:=3
        else if Qtok='ПOCЛEД' then Qo2[Qnm]:=4
        else if Qtok='BЛAДEЛ' then Qo2[Qnm]:=5
        else Qo2[Qnm]:=6;
        QNext;
        if Qtok='B     ' then QNext;  (* B = 'in' before a set name. *)
        Qx1[Qnm]:=Qtok
      end
    end else if Qtok='BЗЯTЬ ' then begin"""
    assert src.count(old) == 1, (name, 'parse')
    src = src.replace(old, new, 1)

    # 4. Execute opcode 24 through the existing QLoadRec/getd path.
    old = """    end else if z=6 then begin
      Qss:=QFindSet(Qx1[Qpc]); if Qss=0 then Qss:=1;
      Qck:=Qbf[(Qcurbuf-1)*8+8]; QNumKey; QLoadRec(1)
    end else if z=7 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qcurbuf:=bno; QLoadRec(bno)
    end else if z=8 then begin"""
    new = """    end else if z=6 then begin
      Qss:=QFindSet(Qx1[Qpc]); if Qss=0 then Qss:=1;
      Qck:=Qbf[(Qcurbuf-1)*8+8]; QNumKey;
      if Qck='      ' then QKeyAt(Qss,1);
      QLoadRec(1)
    end else if z=24 then begin
      (* W8-BYKEY: key = set prefix + 4-digit value of MAD Ц!/A!. *)
      Qss:=QFindSet(Qx2[Qpc]); if Qss=0 then Qss:=1;
      if Qx1[Qpc]<>'      ' then QKeyAt(Qss,ЦX)
      else begin
        if Qsc[Qss]<1 then Qsc[Qss]:=1;
        QKeyAt(Qss,Qsc[Qss])
      end;
      QLoadRec(1);
      writeln('W8-BYKEY SET=',Qsn[Qss],' ARG=',Qx1[Qpc],
              ' KEY=',Qck,' EXN=',QEXN)
    end else if z=7 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qcurbuf:=bno;
      if Qck='      ' then begin
        if Qss<1 then Qss:=1;
        QKeyAt(Qss,1)
      end;
      QLoadRec(bno)
    end else if z=8 then begin"""
    assert src.count(old) == 1, (name, 'exec')
    src = src.replace(old, new, 1)

    # 5. Trace every GETD and keep the existing error handling unchanged.
    old = """begin
  QClrErr; getd(Qck,Qv8);
  if BDERRN<>0 then Qcoc:=1 else begin"""
    new = """begin
  QClrErr; getd(Qck,Qv8);
  writeln('W8-GETD KEY=',Qck,' EXN=',QEXN);
  if BDERRN<>0 then Qcoc:=1 else begin"""
    assert src.count(old) == 1, (name, 'getd')
    src = src.replace(old, new, 1)

    # 6. Loader before the interpreter procedures.
    anchor = 'procedure QLoadRec(bno:integer);'
    assert src.count(anchor) == 1, (name, 'QLoadRec')
    src = src.replace(anchor, loader(name) + '\n' + anchor, 1)

    # 7. Startup: cold init once, then load the verified records.
    if name == 'ZATTAB':
        main = "\nBEGIN\n  DMLCALL(1);\n  TAБЛЗAT\nEND."
        assert src.count(main) == 1, (name, 'main')
        new = ("\nBEGIN\n"
               "  if BDVECT[36].i + 0 = 0 then begin\n"
               "    for i:=0 to 167 do BDVECT[i].i:=0;\n"
               "    i:=20270000c; PASACD(i); PASSETAR(270000c)\n"
               "  end;\n  W8LOAD;\n  DMLCALL(1);\n  TAБЛЗAT\nEND.")
        src = src.replace(main, new, 1)
    elif name == 'ZATMON':
        main = '(* SECTION ? .B *)\nBEGIN KYДA:=' 
        assert src.count(main) == 1, (name, 'main')
        new = ('(* SECTION ? .B *)\nBEGIN\n'
               '  if BDVECT[36].i + 0 = 0 then begin\n'
               '    for i:=0 to 167 do BDVECT[i].i:=0;\n'
               '    i:=20270000c; PASACD(i); PASSETAR(270000c)\n'
               '  end;\n  W8LOAD;\nKYДA:=')
        src = src.replace(main, new, 1)
    else:
        main = """(* SECTION ? .B *)
BEGIN
REGIS;"""
        main_new = """(* SECTION ? .B *)
BEGIN
  if BDVECT[36].i + 0 = 0 then begin
    for i:=0 to 167 do BDVECT[i].i:=0;
    i:=20270000c; PASACD(i); PASSETAR(270000c)
  end;
  W8LOAD;
REGIS;"""
        assert src.count(main) == 1, (name, 'main')
        src = src.replace(main, main_new, 1)
    return src


if __name__ == '__main__':
    name = sys.argv[1]
    inp = Path(sys.argv[2])
    out = Path(sys.argv[3])
    src = inp.read_text(encoding='utf-8')
    out.write_text(patch(name, src), encoding='utf-8', newline='\n')
    print('wrote', out, 'DMLCALL', out.read_text(encoding='utf-8').count('DMLCALL('))
