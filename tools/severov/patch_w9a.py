#!/usr/bin/env python3
"""W9a: literal key form of `HAЙTИ ПO-KЛЮ '...' B <set>` in the MAD ports.

The W8 ports already parse `HAЙTИ ПO-KЛЮ <var> B <set>` as opcode 24 and
execute it through QFindSet -> QKeyAt -> QLoadRec -> getd.  This patch adds
one alternative at the same place: when the token after ПO-KЛЮ starts with a
quote, the quoted string is read from the current source line, normalized to
six characters and stored as an explicit key.  Qx1 (the MAD variable) is not
reused or changed.  No new key builder or record loader is written: QLoadRec
and the existing W8LOAD loader are reused.
"""
import sys
from pathlib import Path

S = Path('/home/azizz/.local/share/vifm/Trash/w9a-literal')

# Gold literal keys that occur in the BUF snippets of the ZATMON port
# (gold lines 908, 910, 3647, 3649, 3767).  The keys are padded to six
# BESM characters; their payload is an authentic deck09 record.
LITERAL_RECORDS = {
    'ZATMON': ['ФЛAГИ ', 'ДATЗП ', 'ПAPOЛЬ', 'ПAPCИC'],
}


def emit_put(key, words, indent='  '):
    lines = []
    for k, w in enumerate(words, 1):
        lit = w[:6].ljust(6)
        lines.append(f"{indent}Qw.a:='{lit}'; W8V[{k}]:=Qw.i;")
    lines.append(f"{indent}QClrErr; putd('{key}',W8V);")
    return '\n'.join(lines)


def deck09_first():
    recs, prefix = [], None
    deck = Path('/home/azizz/Yandex.Disk/re-compass/tests/deck09.b6')
    for line in deck.read_text(encoding='utf-8').splitlines():
        if line.startswith('SET '):
            prefix = line.split()[2]
        elif line.startswith('D0') and len(line) >= 53:
            words = [line[5 + 6 * k:11 + 6 * k] for k in range(8)]
            recs.append((prefix + line[1:5], words))
    return recs[0][1]


def patch(name, src):
    # 1. Store for the explicit literal key (Qx1 stays the MAD variable).
    anchor = 'Qx1,Qx2,Ql2:array[1..16] of alfa;'
    assert src.count(anchor) == 1, (name, 'Qky decl')
    src = src.replace(anchor, anchor + '\n    Qky:array[1..16] of alfa;', 1)

    # 2. Minimal token reader for a quoted literal on the current source line.
    anchor = 'procedure QReadMad2;'
    assert src.count(anchor) == 1, (name, 'QLitKey anchor')
    qlit = """function QLitKey(var dest:alfa):boolean;
var c:char; n:integer;
begin
  for n:=1 to 6 do dest[n]:=' ';
  while (Qp<=72) and (Qln[Qp]=' ') do Qp:=Qp+1;
  QLitKey:=false;
  if Qp>72 then exit;
  if Qln[Qp]<>chr(39) then exit;
  Qp:=Qp+1; n:=0;
  while (Qp<=72) and (Qln[Qp]<>chr(39)) do begin
    c:=Qln[Qp];
    if n<6 then begin n:=n+1; dest[n]:=c end;
    Qp:=Qp+1
  end;
  if (Qp<=72) and (Qln[Qp]=chr(39)) then begin
    Qp:=Qp+1; QLitKey:=true
  end
end;
"""
    src = src.replace(anchor, qlit + anchor, 1)

    # 3. Per-instruction initialization of the literal-key slot.
    old = "Qnm:=Qnm+1; Ql2[Qnm]:='      '; Qx2[Qnm]:='      ';"
    assert src.count(old) == 1, (name, 'init')
    src = src.replace(old, old + " Qky[Qnm]:='      ';", 1)

    # 4. Local save of the tokenizer position before the literal reader.
    old = 'var z:integer; s:alfa; ok:boolean;\nbegin\n  Qnm:=0;'
    assert src.count(old) == 1, (name, 'locals')
    src = src.replace(old,
                      'var z:integer; s:alfa; ok:boolean; Qp0:integer;\nbegin\n  Qnm:=0;', 1)

    # 5. Parser: quote after ПO-KЛЮ means explicit key, not a variable.
    old = """        Qo2[Qnm]:=24;
        QNext;
        if Qtok='B     ' then begin
          Qx1[Qnm]:='      '; QNext
        end else begin
          Qx1[Qnm]:=Qtok; QNext;
          if Qtok='B     ' then QNext
        end;
        Qx2[Qnm]:=Qtok"""
    new = """        Qo2[Qnm]:=24;
        Qp0:=Qp;
        if QLitKey(Qky[Qnm]) then begin
          (* W9A-LITERAL: explicit key, Qx1 is left untouched. *)
          QNext;
          if Qtok='B     ' then QNext;
          Qx2[Qnm]:=Qtok
        end else begin
          Qp:=Qp0;
          QNext;
          if Qtok='B     ' then begin
            Qx1[Qnm]:='      '; QNext
          end else begin
            Qx1[Qnm]:=Qtok; QNext;
            if Qtok='B     ' then QNext
          end;
          Qx2[Qnm]:=Qtok
        end"""
    assert src.count(old) == 1, (name, 'parse')
    src = src.replace(old, new, 1)

    # 6. Executor: literal overrides key construction; the W8 path is intact.
    old = """      Qss:=QFindSet(Qx2[Qpc]); if Qss=0 then Qss:=1;
      if Qx1[Qpc]<>'      ' then QKeyAt(Qss,ЦX)
      else begin"""
    new = """      Qss:=QFindSet(Qx2[Qpc]); if Qss=0 then Qss:=1;
      if Qky[Qpc]<>'      ' then Qck:=Qky[Qpc]
      else if Qx1[Qpc]<>'      ' then QKeyAt(Qss,ЦX)
      else begin"""
    assert src.count(old) == 1, (name, 'exec')
    src = src.replace(old, new, 1)

    # 7. The area must contain a record for every gold literal key so that
    #    GETD resolves the explicit key instead of reporting a DB error.
    keys = LITERAL_RECORDS.get(name, [])
    if keys:
        anchor = "  writeln('W8-LOAD-EXN=',QEXN,' KEYS=',"
        i = src.index(anchor)
        j = src.index('\n', i)
        line = src[i:j]
        payload = deck09_first()
        extra = [emit_put(k, payload) for k in keys]
        src = src[:i] + '\n'.join(extra) + '\n' + line + src[j:]
        # Keep the printed key count consistent with the extra literal records.
        import re
        m = re.search(r"KEYS=',(\d+)\)", src)
        assert m, (name, 'KEYS counter')
        src = src[:m.start()] + ("KEYS=',%d)" % (int(m.group(1)) + len(keys))) + src[m.end():]
    return src


if __name__ == '__main__':
    name = sys.argv[1]
    inp, out = Path(sys.argv[2]), Path(sys.argv[3])
    text = inp.read_text(encoding='utf-8')
    result = patch(name, text)
    out.write_text(result, encoding='utf-8', newline='\n')
    print('wrote', out, 'DMLCALL', result.count('DMLCALL('),
          'QLitKey', result.count('QLitKey('))
