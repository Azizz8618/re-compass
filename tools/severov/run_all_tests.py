#!/usr/bin/env python3
"""Полный прогон всех дек Северова на simh/dispak.

Каждая сессия начинается с нетронутых копий образов и стандартного патча
ядра МАРС (`tools/mars/patch_workdisk.sh`). Логи и сравнение с эталонами
сохраняются в <work>/logs. Оригиналы в ~/.besm6 и /usr/local/share/besm6
не изменяются.

Использование:
    python3 tools/severov/run_all_tests.py [--work DIR] [--repo DIR]
"""

import argparse
import os
import re
import shutil
import subprocess
from pathlib import Path

DISKS = ['2048', '2053', '2099', '2148', '2348', '2196']

SESSIONS = [
    ('gold-phase1',
     ['comtup_final_build', 'servis_build4'],
     ['original_deck_front', 'gold_servis', 'gold_servis_other', 'ttc15',
      'genmad', 'predtgen', 'gold_shtamp', 'gold_shtamp_v']),
    ('standalone', ['comtup_final_build'],
     ['mars_smoke', 'adatars', 'aremars', 'bpmars', 'scmars',
      'deck03', 'deck04-schema-am', 'deck05-fortran-startup', 'deck08',
      'deck09', 'deck10-schema-zat']),
    ('servis', ['comtup_final_build'],
     ['servis_build', 'servis_ops', 'servis_build4', 'servis_ops4']),
    ('chunk', [], ['chunk_w1', 'chunk_w2', 'chunk_reader']),
    ('comtup', ['comtup_final_build'],
     ['comtup_final_test', 'comtup_state_test', 'comtup_test', 'kompas_suite',
      'pic_ops_66_67_76_77', 'cgetbdkey', 'cgetbdkey_external',
      'cgetbdkey_external_fixed', 'cgetbdkey_fixture', 'cgetbdkey_single',
      'cputbdkey_put', 'cputbdkey_persist']),
    ('tss', ['comtup_final_build', 'ucompas_build', 'tssdml_build',
             'tsspr3300_build'],
     ['ucompas_test', 'tsspr-linked-ucompas', 'tsspr-v12-linked',
      'tsspr-v12-probe', 'direct13_3260', 'dmlall13']),
]


def norm(data):
    return re.sub(rb'\d{2}\.\d{2}\.26', b'DD.MM.26', data)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--work', type=Path, default=Path('/tmp/.private/azizz/severov-all'))
    ap.add_argument('--repo', type=Path,
                    default=Path(__file__).resolve().parents[2])
    args = ap.parse_args()
    work, repo = args.work, args.repo
    pristine, logs = work / 'pristine', work / 'logs'
    pristine.mkdir(parents=True, exist_ok=True)
    logs.mkdir(parents=True, exist_ok=True)
    for d in DISKS:
        if d == '2196':
            src = Path.home() / 'Yandex.Disk/dispak/tests/disks/2196'
        else:
            src = Path.home() / '.besm6' / d
        if not (pristine / d).exists():
            shutil.copy2(src, pristine / d)

    def reset():
        for d in DISKS:
            shutil.copy2(pristine / d, work / d)
        env = dict(os.environ, BESM6_PATH=str(work))
        subprocess.run(['bash', str(repo / 'tools/mars/patch_workdisk.sh'), str(work)],
                       env=env, check=True, stdout=subprocess.DEVNULL,
                       stderr=subprocess.PIPE)

    def deck(name, tag=None):
        tag = tag or name
        p = subprocess.run(['dispak', '--path=.', '-p', str(repo / 'tests' / (name + '.b6'))],
                           cwd=work, input=b'', stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, timeout=180)
        (logs / (tag + '.run')).write_bytes(p.stdout)
        (logs / (tag + '.err')).write_bytes(p.stderr)
        exp = repo / 'tests' / (name + '.expected.txt')
        status = 'NO_EXPECTED'
        if exp.exists():
            status = 'MATCH' if norm(exp.read_bytes()) == norm(p.stdout) else 'DIFF'
        print(f'{name:30s} rc={p.returncode:3d} stderr={len(p.stderr):4d} '
              f'******={p.stdout.count(b"******"):3d} {status}', flush=True)

    for label, builds, tests in SESSIONS:
        print(f'=== {label} ===', flush=True)
        reset()
        for b in builds:
            deck(b, 'build-' + b)
        for t in tests:
            deck(t)
    print(f'логи: {logs}')


if __name__ == '__main__':
    main()
