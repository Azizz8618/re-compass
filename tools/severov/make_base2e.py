#!/usr/bin/env python3
"""Extend the W5d BASE2 shim with exact 6-bit record declarations.

The W5d shim was generated from a coarse identifier list: record variables
were declared as types or empty procedures, which produced diagnostics 11,
23 and 68 in the remaining applications.  This script replaces those
declarations by records whose field spellings are copied verbatim from the
KOMPAS sources.  The frozen W5d shim is kept for the six byte-identical
programs.
"""
import importlib.util
import re
from pathlib import Path

B = Path('/home/azizz/.local/share/vifm/Trash/tss-w5e-fix/tools/shims')


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.SHIM


def drop_decl(text, pattern):
    lines = text.split('\n')
    out = []
    skip = 0
    for line in lines:
        if skip:
            skip -= 1
            continue
        if re.match(pattern, line.strip(), re.I):
            if 'begin' not in line:
                skip = 1
            continue
        out.append(line)
    return '\n'.join(out)


def main():
    sh = load(B / 'BASE2_W5D.py', 'base2_w5d')
    types, vars_, procs = sh['types'], sh['vars'], sh['procs']
    # ZVESH fields are shared with SKLCAR's real-valued arithmetic.
    types = types.replace('ЦEHA:integer;', 'ЦEHA:real;')
    types = types.replace('ZVZYAL=record KOЛИЧ:integer end', 'ZVZYAL=record KOЛИЧ:real end')
    types = types.replace('ZSUM=record ЦEHA:integer end', 'ZSUM=record ЦEHA:real end')
    types = types.replace('OCTAT:integer; ПPИXOД:integer; PACXOД:integer',
                          'OCTAT:real; ПPИXOД:real; PACXOД:real')

    # Identifiers that must be record variables, not types or procedures.
    for pat in [r'^ДЕЙ=record', r'^СТОИТ=record']:
        types = drop_decl(types, pat)
    for name in ['ГРУППА', 'ПАР', 'ИНВ', 'ШИФР', 'МЕТАЛ', 'ИСПОЛН',
                 'ЭТАП', 'ТЕМА', 'ЗАТ', 'НАКЛ', 'ВОС', 'ТОЛЬКОСИ', 'SETFLAG', 'FIL', 'RЕАDСОN', 'NЕХТРАR', 'ОЗАРП', 'ДЗАРП', 'WМЕС', 'WRЕАL', 'ЗАНАК', 'CLF', 'СLF']:
        procs = drop_decl(procs, r'^function %s\b|^procedure %s\b' % (name, name))
    for pat in [r'^МАТЕР:', r'^ЦЕЛ:', r'^EД:', r'^ВОS:', r'^WРИ:']:
        vars_ = drop_decl(vars_, pat)

    new_types = '''
  TMAT=record HAЗB:alfa; HAЧ:integer; KOH:integer end;
  TSROC=record HAЗB:alfa; HAЧ:integer; KOH:integer end;
  TINV=record HOMEP:integer; N:integer end;
  TSHIF=record HOMEP:integer end;
  TMET=record HAЗB:alfa end;
  TDR=record HAЗB:alfa; KOЛИЧ:real end;
  TCONT=record KOЛИЧ:real end;
  TSTOR=record ИHB:TINV; ШИФP:TSHIF; ЦEHA:real; BOC:real; KAП:real; X:integer end;
  TSTOI=record ПPИHЯЛ:integer; CПИCAЛ:integer end;
  TALF=record ЗH:alfa end;
  TDEY=record ЗH:real end;
  TCEL=record ЗH:real end;
  TFAK=record ЗATPAT:real end;
  TPAR=record COKP:alfa; HAЗB:alfa; ИMЯ:alfa end;
  TZAT=record MEC:integer; ЗН:real end;
  TISP=record HOMEP:integer; УРОВ:integer end;
  TETAP=record HOMEP:integer end;
  TTEMA=record HOMEP:integer end;
  TBOS=record NAM:alfa; N:integer end;
  TBOSREC=record NAM:alfa; N:integer end;
  TCUL=record CUCX:TBOSREC; CUPX:TBOSREC end;
  TCONTENT=record NAM:alfa; ZN:real end;
  CONTENT=record NAM:alfa; ZN:real end;
  TNAKL=record MEC:integer; ЗAPП:real; ПPOЧ:real; HAКЛ:real; ЗAPH:real; ЗAPП_:real end;
  TSETCOL=record BЫЧДEЙ:integer; CLEAN:integer; CYMДEЙ:integer; ИCXДEЙ:integer end;
'''
    types += new_types

    new_vars = '''
  MATEP:TMAT;
  CTOИT:TSTOI;
  ГPYППA:TSROC;
  ДEЙ:TDEY;
  ПAP:TPAR;
  ДP_:TDR;
  COДEPЖ:TCONT;
  ИHB:TINV;
  ШИФP:TSHIF;
  METAЛ:TMET;
  ПPИБOP:TSTOR;
  AЛФ:TALF;
  ЦEЛ:TCEL;
  ФAKTИЧ:TFAK;
  ЗAT:TZAT;
  ИCПOЛH:TISP;
  ЭTAП:TETAP;
  TEMA:TTEMA;
  BOS_:TBOS;
  CUL_:TCUL;
  HAКЛ:TNAKL;
  EД:alfa;
  ЦX:integer;
  ДX:real;
  CX:CONTENT;
  ОЗАРП:real;
  ДЗАРП:real;
  ЗАНАК:real;
  CLF:char;
  ЗН:real;
  FОRLIN:integer;
  FIL:integer;
  ТОЛЬКОСИ:boolean;
  SETCOL:TSETCOL;
  HAЗB:alfa;
  ЦЕНА:real;
  ПРИХОД:real;
  ОСТАТ:real;
  РАСХОД:real;
'''
    vars_ += new_vars

    new_procs = '''
function ЕЩЕ(S:alfa):boolean;
begin ЕЩЕ:=false end;
function CONFIRM:boolean;
begin CONFIRM:=false end;
function NEXTCON:boolean;
begin NEXTCON:=false end;
function NEXTPAR:boolean;
begin NEXTPAR:=false end;
function NЕХТРАR:boolean;
begin NЕХТРАR:=false end;
procedure LOADLIST(S:alfa);
begin end;
procedure FINDLIST(S:alfa);
begin end;
procedure FINDPAR(S:alfa);
begin end;
procedure CLEANALL;
begin end;
procedure HAЙTИ;
begin end;
procedure WRITELIST;
begin end;
procedure WМЕС(var F:text; N:integer);
begin end;
procedure WRЕАL(A:real; N:integer);
begin end;
procedure RЕАDСОN(var N:boolean);
begin N:=false end;
procedure NЕWСОNТ(var C:CONTENT);
begin end;
procedure RЕSЕТСОN;
begin end;
procedure READCON(var N:boolean);
begin N:=false end;
procedure INPUTCON;
begin end;
procedure CLEANCON;
begin end;
procedure RESETPAR;
begin end;
procedure ИCK;
begin end;
procedure НOB;
begin end;
procedure ПOCTAB;
begin end;
procedure BЗЯTЬ;
begin end;
procedure ИCKЛЮЧEHИE;
begin end;
'''
    from gostnorm import gostbytes
    seen = set(gostbytes(m.group(1)) for m in re.finditer(
        r'\b([A-Za-zА-Яа-яЁё][A-Za-zА-Яа-яЁё0-9_]*)\b', procs))
    kept = []
    skip_body = False
    for line in new_procs.split('\n'):
        if skip_body:
            skip_body = False
            continue
        m = re.match(r'\s*(?:procedure|function)\s+([\wА-Яа-яЁё]+)', line)
        if m:
            key = gostbytes(m.group(1))
            if key in seen:
                skip_body = True
                continue
            seen.add(key)
        kept.append(line)
    procs += '\n'.join(kept)

    out = B / 'BASE2.py'
    out.write_text(
        'TYPES = ' + repr(types) + '\n\nVARS = ' + repr(vars_) +
        '\n\nPROCS = ' + repr(procs) +
        '\n\nSHIM = dict(types=TYPES, vars=VARS, procs=PROCS)\n',
        encoding='utf-8')
    print('BASE2 extended:', len(new_types.splitlines()) - 1, 'types,',
          len(new_vars.splitlines()) - 1, 'vars,',
          len(new_procs.splitlines()) - 1, 'procs')


if __name__ == '__main__':
    main()
