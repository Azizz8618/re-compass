#!/usr/bin/env python3
"""Build a broad W5D shim from the W5c missing-identifier inventory.

The canonical spellings in W5C-MISSING-IDS.txt are used verbatim: their 6-bit
codes match the tokens in the gold text.  Names that are clearly procedures,
record variables, sets or flags get the matching declaration kind; everything
else starts as an integer variable and is refined from compiler diagnostics.
"""
import re
from pathlib import Path

BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5d-fix')
MISS = Path('/home/azizz/Yandex.Disk/re-compass/docs/severov-apps/W5C-MISSING-IDS.txt')

PROCS = {
    'ОUТ', 'ЕХIТ', 'РUТТ', 'РUТРТ', 'РUТР', 'WДАТ', 'WСТР', 'GЕТТ',
    'GЕТНАЧ', 'GЕТD', 'УСТМОД', 'УСТПЕЧ', 'ЕСТЬ', 'ПЗГ', 'SETFLAG',
    'ЖУРНАЛ', 'КОНЕЦ', 'МЕNU', 'БЛОКСИС', 'ПАРОЛЬ', 'ПРАВА', 'ПРЕДЗАК',
    'СНЯФЛАГ', 'УСТФЛАГ', 'ЗАКРЫТО', 'МОЖНО', 'ПУСТО', 'STOP',
    'RЦЕЛ', 'RДАТ', 'RВЕЩ', 'RЦЕЛBEЩ', 'RСТР', 'ДАТЧИС', 'ДАТЧИС',
    'WRI', 'RЕSЕТСОN', 'RЕSЕТРАR', 'СLЕАNСОN', 'RЕАDСОN', 'NЕХТРАR',
    'NЕХТ', 'СLF', 'FПАР', 'FСВЯ', 'FСОРУ', 'FF', 'FWRIТЕ', 'WLF',
    'WВL', 'МINUSЕS', 'МЕТАЛ', 'ИНВ', 'Ц', 'Ц1', 'ЦЕНА', 'ШИФР',
    'ГРУППА', 'ВОС', 'КАП', 'ПАР', 'Т', 'ДЕЙ', 'ТОЛЬКОСИ', 'ЭТАП',
    'АТХ', 'НОМЕР', 'УРОВ', 'ТЕМА', 'ПРОЧ', 'НАКЛ', 'ЗАНАК', 'ЗАРП',
    'ВЫП', 'ОЗАРП', 'ДЗАРП', 'КОМАН', 'СПЕЦ', 'АМОР', 'СТОР', 'ПОСН',
    'ПТРЕС', 'ПРБК', 'ОВЫШ', 'ОГОС', 'НЕПЛ', 'ИСПОЛН', 'ОТДЕЛ',
    'ЗАТ', 'СУММА', 'МЕС', 'NАМ', 'WRЕАL', 'WМЕС', 'СR', 'ZNАК',
    'РUТР', 'ПТР', 'RЦЕЛ', 'ДАТЧИС', 'RДАТ', 'WДАТ',
}

RECORDS = {
    'SУSТЕМ': ('record РЕЖИМЫ:ZFLGS; ХРАНИМ:ZFLGS; ГОД:integer; ДАТЗП:integer; '
              'ВРЕЗП:integer; ДАТЧИС:integer; ПАРСИС:alfa; ПАРОЛЬ:alfa end'),
    'ОТДЕЛ': 'record НАЗВ:alfa end',
    'BEЩЬ': 'record HOMEP:integer; НАЗВ:alfa; ЦЕНА:integer; OCTAT:integer; '
            'ПРИХОД:integer; РАСХОД:integer; МЕТАЛ:alfa; ИНВ:alfa; '
            'ГРУППА:alfa; ШИФР:alfa; КОЛИЧ:integer end',
    'ВЗЯЛ': 'record КОЛИЧ:integer end',
    'CYMMA': 'record ЦЕНА:integer end',
    'ПРОВ': 'record ПАРОЛЬ:alfa end',
    'ПАР': 'record НАЗВ:alfa end',
    'ВОS': 'record NAM:alfa; N:integer end',
    'CUL': 'record CUC:alfarec; CUP:alfarec end',
    'C': 'record NAM:alfa end',
}

ALFA = {'КУДА', 'ДИР', 'ДИP', 'ПАРСИС', 'ПАРОЛЬ', 'НАЗВ', 'МЕТАЛ', 'ИНВ',
        'ШИФР', 'ГРУППА', 'Ц', 'Ц1', 'T', 'Т', 'МЕС', 'NАМ', 'ZNАК'}

SETS = {'ФЛАГИ', 'ЗАКРЫТО', 'МОЖНО', 'ПУСТО', 'RGEXPORT'}

FALGS = {'ОТЛАД', 'АДМИН', 'ОТЧСКЛ', 'ОТЧОТД', 'ВХОД', 'ФS'}


def main():
    names = []
    section = None
    for line in MISS.read_text(encoding='utf-8').splitlines():
        if line.startswith('====='):
            section = line.strip('= ')
            continue
        m = re.match(r'\s*\d+\s+(\S+)', line)
        if m:
            names.append(m.group(1))
    uniq = []
    for n in names:
        if n not in uniq:
            uniq.append(n)

    vars_ = []
    procs_ = []
    seen = set()
    for n in uniq:
        if n in seen:
            continue
        seen.add(n)
        if n in PROCS:
            procs_.append('procedure %s;\nbegin end;' % n)
        elif n in RECORDS:
            vars_.append('%s:%s;' % (n, RECORDS[n]))
        elif n in ALFA:
            vars_.append('%s:alfa;' % n)
        elif n in SETS:
            vars_.append('%s:boolean;' % n)
        else:
            vars_.append('%s:integer;' % n)

    types = '''
  INT=integer;
  ZFLG=(%s);
  ZFLGS=set of ZFLG;
  ALFAREC=record NAM:alfa end;
''' % ','.join(sorted(FALGS))
    base = Path(BASE / 'tools' / 'shims' / 'BASE.py')
    base.write_text(
        'TYPES = ' + repr(types) + '\n\nVARS = ' + repr('\n  '.join(vars_)) +
        '\n\nPROCS = ' + repr('\n'.join(procs_)) +
        '\n\nSHIM = dict(types=TYPES, vars=VARS, procs=PROCS)\n',
        encoding='utf-8')
    print('BASE shim:', len(vars_), 'vars,', len(procs_), 'procs')


if __name__ == '__main__':
    main()
