#!/usr/bin/env python3
"""BASE2 shim: the validated SKLMON shim plus conservative declarations for
identifiers seen in the other 15 programs' W5c logs.

All declarations are de-duplicated by their 6-bit GOST codes, because Latin
and Cyrillic homoglyphs can spell the same compiler identifier.
"""
import importlib.util
import re
import sys
from pathlib import Path

BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5d-fix')
MISS = Path('/home/azizz/Yandex.Disk/re-compass/docs/severov-apps/W5C-MISSING-IDS.txt')
sys.path.insert(0, str(BASE / 'tools'))
from gostnorm import gostbytes


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.SHIM


def main():
    sh = load(BASE / 'tools' / 'shims' / 'SKLMON.py', 'sk_shim')
    seen = set(gostbytes(w) for w in re.findall(
        r'[A-Za-zА-Яа-яЁё][A-Za-zА-Яа-яЁё0-9_]*',
        sh['types'] + sh['vars'] + sh['procs']))

    names = []
    for line in MISS.read_text(encoding='utf-8').splitlines():
        m = re.match(r'\s*\d+\s+(\S+)', line)
        if m and m.group(1) not in names:
            names.append(m.group(1))

    proc_names = set('''ЕХIТ ОUТ РUТР WРИ RЕSЕТСОN RЕSЕТРАR СLЕАNСОN
RЕАDСОN NЕХТРАR NЕХТ СLF FПАР FСВЯ FСОРУ FF FWRIТЕ WLF WВL МINUSЕS
МЕТАЛ ИНВ Ц Ц1 ЦЕНА ШИФР ГРУППА ВОС КАП ПАР Т ДЕЙ ТОЛЬКОСИ ЭТАП АТХ
НОМЕР УРОВ ТЕМА ПРОЧ НАКЛ ЗАНАК ЗАРП ВЫП ОЗАРП ДЗАРП КОМАН СПЕЦ АМОР
СТОР ПОСН ПТРЕС ПРБК ОВЫШ ОГОС НЕПЛ ИСПОЛН ЗАТ СУММА МЕС NАМ WRЕАL
WМЕС СR ZNАК ПТР RЦЕЛBEЩ RСТР ДАТЧИС WДАТ WСТР RЦЕЛ RДAT'''.split())
    alfa_names = set('КУДА ДИP ПАРСИС ПАРОЛЬ НАЗВ ШИФР ГРУППА NАМ ZNАК МЕС Ц Ц1 Т ПАР'.split())
    bool_names = set('НЕЛЬЗЯ ЗAKPЫTO MOЖHO ПYCTO ДА HAЧ МОЖНО ПУСТО ЕЩЕ ЕСТЬ'.split())

    skip = set('''SТРUТ SТЕР NЕХТ ЦЕЛ LF МАХШИФР МINШИФР СТОИТ ДЕЙ
ЕЩЕ ОЦЕНЕНО ЕСТЬВЗЯЛ ЭТОТМЕС ЕСТЬЗАТ RОТД FПАР WLF WВL МINUSЕS
FWRIТЕ УСТПЕЧ RЕSЕТСОN RЕSЕТРАR СLЕАNСОN ПЕЧКОЭФ РЕGIS WТRЕЕ RВЕЩ'''.split())
    proc_names -= skip
    vars_, procs_ = [], []
    def add_var(name, decl):
        if gostbytes(name) in seen:
            return
        seen.add(gostbytes(name))
        vars_.append(decl)

    def add_proc(name, decl):
        if gostbytes(name) in seen:
            return
        seen.add(gostbytes(name))
        procs_.append(decl)

    for n in names:
        if n in skip:
            continue
        if n in proc_names:
            add_proc(n, 'procedure %s;\nbegin end;' % n)
        elif n in alfa_names:
            add_var(n, '%s:alfa;' % n)
        elif n in bool_names:
            add_var(n, '%s:boolean;' % n)
        else:
            add_var(n, '%s:integer;' % n)

    extra_types = '''
  ВООL=boolean;
  SТРОКА=alfa;
  СТРОКА=alfa;
  ZZОТДЕЛ=record НАЗВ:alfa end;
  ZZГРУППА=record НАЗВ:alfa; НАЧ:integer; КОН:integer end;
  ZZВDКЕУ=record КЛЮЧ:alfa; ЗНАЧ:integer end;
  ДИРЕКТ=record ИМЯ:alfa; НАЗВ:alfa end;
  ДЕЙ=record ЗН:real end;
  СТОИТ=record ПРИНЯЛ:integer; СПИСАЛ:integer end;
  ZЗАТ=record МЕС:integer; НОМЕР:integer; ЗН:integer end;
  ZИСПОЛН=record НОМЕР:integer; УРОВ:integer end;
  ZLINЕ=record S:integer; F:char end;
  ZСЕLL=record FRМ:char; СОN:integer end;
'''
    types = sh['types'] + extra_types

    for name, decl in [
        ('SТРUТ', 'SТРUТ:boolean;'), ('SТЕР', 'SТЕР:boolean;'),
        ('NЕХТ', 'NЕХТ:boolean;'), ('ЦЕЛ', 'ЦЕЛ:ZLINЕ;'),
        ('LF', 'LF:char;'), ('МАХШИФР', 'МАХШИФР:integer;'),
        ('МINШИФР', 'МINШИФР:integer;'),
    ]:
        add_var(name, decl)

    extra_procs = [
        ('ЕЩЕ', 'function ЕЩЕ(S:alfa):boolean;\nbegin ЕЩЕ:=false end;'),
        ('ОЦЕНЕНО', 'function ОЦЕНЕНО:boolean;\nbegin ОЦЕНЕНО:=false end;'),
        ('ЕСТЬВЗЯЛ', 'function ЕСТЬВЗЯЛ:boolean;\nbegin ЕСТЬВЗЯЛ:=false end;'),
        ('ЭТОТМЕС', 'function ЭТОТМЕС:boolean;\nbegin ЭТОТМЕС:=false end;'),
        ('ЕСТЬЗАТ', 'function ЕСТЬЗАТ:boolean;\nbegin ЕСТЬЗАТ:=false end;'),
        ('RОТД', "function RОТД:alfa;\nbegin RОТД:='      ' end;"),
        ('FПАР', 'procedure FПАР(S:alfa);\nbegin end;'),
        ('WLF', 'procedure WLF(N:integer);\nbegin end;'),
        ('WВL', 'procedure WВL(N:integer);\nbegin end;'),
        ('МINUSЕS', 'procedure МINUSЕS;\nbegin end;'),
        ('FWRIТЕ', 'procedure FWRIТЕ(var F:text);\nbegin end;'),
        ('УСТПЕЧ', 'procedure УСТПЕЧ;\nbegin end;'),
        ('RЕSЕТСОN', 'procedure RЕSЕТСОN;\nbegin end;'),
        ('RЕSЕТРАR', 'procedure RЕSЕТРАR;\nbegin end;'),
        ('СLЕАNСОN', 'procedure СLЕАNСОN;\nbegin end;'),
        ('ПЕЧКОЭФ', 'procedure ПЕЧКОЭФ;\nbegin end;'),
        ('РЕGIS', 'procedure РЕGIS;\nbegin end;'),
        ('WТRЕЕ', 'procedure WТRЕЕ;\nbegin end;'),
        ('RВЕЩ', 'function RВЕЩ(A,B:real):real;\nbegin RВЕЩ:=A end;'),
    ]
    for name, decl in extra_procs:
        add_proc(name, decl)

    out = BASE / 'tools' / 'shims' / 'BASE2.py'
    out.write_text(
        'TYPES = ' + repr(types) + '\n\nVARS = ' +
        repr(sh['vars'] + '\n  ' + '\n  '.join(vars_)) + '\n\nPROCS = ' +
        repr(sh['procs'] + '\n' + '\n'.join(procs_)) +
        '\n\nSHIM = dict(types=TYPES, vars=VARS, procs=PROCS)\n',
        encoding='utf-8')
    print('BASE2:', len(vars_), 'extra vars,', len(procs_), 'extra procs')


if __name__ == '__main__':
    main()
