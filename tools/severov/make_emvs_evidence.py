#!/usr/bin/env python3
# Generate EVIDENCE.txt with verbatim source lines. Read-only over sources.
from pathlib import Path

OUT = Path('/home/azizz/.local/share/vifm/Trash/emvs-study/EVIDENCE.txt')

D = Path('/home/azizz/Yandex.Disk/aesc-crypto-projects/docs')
PLAN = D / 'espd/План_внедрения_блочного_шифрования_задание_3_печать.txt'
COMPASS = Path('/home/azizz/Yandex.Disk/re-compass/docs')
MRV = Path('/home/azizz/Yandex.Disk/re-mrv/docs')
SIMH = Path('/home/azizz/Yandex.Disk/simh/BESM6')

RANGES = [
    (PLAN, 201, 209, 'План, ВВЕДЕНИЕ: ЕМВС как пример многомашинного комплекса'),
    (PLAN, 226, 232, 'План, ВВЕДЕНИЕ: восстановление КАДОПАМ-ДКС и эмуляторов терминалов'),
    (PLAN, 809, 837, 'План, 1.2: экстракоды 070/064/063/0157/0116/050, паспорта'),
    (PLAN, 865, 893, 'План, 1.3: эмуляторы dispak и simh'),
    (PLAN, 1073, 1121, 'План, 2. НАЗНАЧЕНИЕ РАЗРАБОТКИ: объекты защиты и границы'),
    (PLAN, 1637, 1655, 'План, 4.1: точка интеграции - обработчик ЭК 070'),
    (PLAN, 3881, 3908, 'План, ПРИЛОЖЕНИЕ 2: deck 1 header'),
    (PLAN, 3932, 3938, 'План, ПРИЛОЖЕНИЕ 2: deck 2 header'),
    (PLAN, 3964, 3973, 'План, ПРИЛОЖЕНИЕ 2: deck 3 header'),
    (PLAN, 4023, 4059, 'План, ПРИЛОЖЕНИЕ 3: описание ЕМВС'),
    (PLAN, 4088, 4131, 'План, ПРИЛОЖЕНИЕ 3: ДРАКОН-схема ЕМВС'),
    (D / 'methodology.md', 18, 26, 'methodology.md 1: среда и том 2348'),
    (D / 'methodology.md', 33, 51, 'methodology.md 2: пять особенностей'),
    (D / 'methodology.md', 148, 160, 'methodology.md 7: исторический контекст'),
    (D / 'glossary.md', 10, 18, 'glossary: АРФА, АЦПУ'),
    (D / 'glossary.md', 45, 58, 'glossary: ДИСПАК, ДКС, ЕМВС'),
    (D / 'glossary.md', 66, 68, 'glossary: Зона'),
    (D / 'glossary.md', 103, 105, 'glossary: Монитор-80'),
    (D / 'glossary.md', 151, 153, 'glossary: Спецноситель 203'),
    (D / 'glossary.md', 170, 179, 'glossary: Том, Том 2053'),
    (D / 'glossary.md', 187, 190, 'glossary: Экстракод'),
    (D / 'toolkit.md', 74, 89, 'toolkit 1.3: dispak'),
    (D / 'toolkit.md', 116, 128, 'toolkit 1.4: simh'),
    (D / 'toolkit.md', 130, 149, 'toolkit 1.5: СИПРОД/re-siprod'),
    (D / 'toolkit.md', 159, 176, 'toolkit 2: смежные проекты'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 7, 26, 're-compass, легенда и три пути передачи'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 28, 37, 're-compass, таблица среды'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 39, 54, 're-compass, шапка колоды'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 56, 67, 're-compass, этап 1'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 80, 90, 're-compass, этап 3'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 103, 119, 're-compass, этапы 5-6'),
    (COMPASS / 'TRAINING-TASK-COMPASS-INFOSEC.md', 137, 144, 're-compass, ограничения'),
    (COMPASS / 'COMPASS-USER-GUIDE.md', 5, 16, 're-compass, компоненты на томе 2348'),
    (COMPASS / 'COMPASS-USER-GUIDE.md', 57, 81, 're-compass, шапка задания'),
    (COMPASS / 'COMPASS-USER-GUIDE.md', 83, 100, 're-compass, операторы SERVIS'),
    (COMPASS / 'COMPASS-USER-GUIDE.md', 171, 184, 're-compass, контроль зон и ограничения'),
    (COMPASS / 'COMPASS-JOB-TEMPLATE.md', 6, 17, 're-compass, подготовка и HOME'),
    (COMPASS / 'COMPASS-JOB-TEMPLATE.md', 19, 44, 're-compass, шапка задания'),
    (COMPASS / 'ARE-DATA.md', 1, 18, 're-compass, формат области .ARE'),
    (COMPASS / 'ARE-DATA.md', 43, 60, 're-compass, путь переноса в МАРС'),
    (COMPASS / 'DISK-2348.md', 1, 24, 're-compass, карта диска 2348'),
    (COMPASS / 'DISK-2348.md', 35, 52, 're-compass, 2348 как носитель кода МАРС'),
    (COMPASS / 'ZONE-ALLOCATION.md', 1, 20, 're-compass, разрешённые зоны записи'),
    (COMPASS / 'ZONE-ALLOCATION.md', 36, 50, 're-compass, проверка перед записью'),
    (COMPASS / 'KOMPAS-BESM.md', 5, 26, 're-compass, граница КОМПАС/СУБД'),
    (COMPASS / 'KOMPAS-BESM.md', 28, 38, 're-compass, МАРС-6 и формат хранения'),
    (MRV / 'K71_LOCAL_OSINT.md', 21, 59, 're-mrv, подтверждённые факты по К-71 и КАДОПАМ'),
    (MRV / 'K71_LOCAL_OSINT.md', 63, 107, 're-mrv, карта событий, пакеты, прерывания'),
    (MRV / 'K71_LOCAL_OSINT.md', 153, 178, 're-mrv, покрытие реконструкцией'),
    (MRV / 'K71_MRV_SUBSYSTEMS.md', 154, 175, 're-mrv, подсистемы МРВ'),
    (MRV / 'K71_MRV_SUBSYSTEMS.md', 179, 214, 're-mrv, каналы, 032/132'),
    (MRV / 'K71_RUKDKS.md', 6, 41, 're-mrv, выжимка из rukdks.be'),
    (MRV / 'K71_RUKDKS.md', 43, 73, 're-mrv, H/S-машины и прерывания'),
    (SIMH / 'doc/ДКС.md', 7, 14, 'simh, что такое КАДОПАМ'),
    (SIMH / 'doc/ДКС.md', 16, 41, 'simh, 032/132 в исходниках и симуляторе'),
    (SIMH / 'doc/ДКС.md', 43, 85, 'simh, выбор Э-60 и прерывания'),
    (SIMH / 'doc/ДКС.md', 88, 139, 'simh, карта памяти КАДОПАМ'),
    (SIMH / 'doc/ДКС.md', 141, 194, 'simh, вывод/ввод удалённого терминала'),
    (SIMH / 'doc/ДКС.md', 196, 230, 'simh, ячейка 0 и ПРП 12'),
    (SIMH / 'doc/ДКС.md', 302, 346, 'simh, Э50 133'),
    (SIMH / 'doc/ДКС.md', 396, 417, 'simh, конфигурирование терминалов'),
    (SIMH / 'doc/ДКС.md', 517, 532, 'simh, ТАЙНА'),
    (SIMH / 'doc/ДКС.md', 562, 606, 'simh, модель КАДОПАМ/ДКС'),
    (SIMH / 'besm6_dks.c', 30, 44, 'simh, kommentar к устройству DKS'),
    (SIMH / 'besm6_dks.c', 56, 86, 'simh, адреса и лимиты'),
    (SIMH / 'besm6_dks.c', 93, 120, 'simh, память и REMOTE-режим'),
    (SIMH / 'README/AGENTS.md', 87, 125, 'simh, рабочий документ по поддержке ДКС'),
    (Path('/home/azizz/Yandex.Disk/ie15/README.md'), 1, 11, 'ie15, подключение к SIMH'),
    (Path('/home/azizz/Yandex.Disk/ie15/README.md'), 15, 23, 'ie15,_parameters'),
    (Path('/home/azizz/Yandex.Disk/ie15/README.md'), 163, 164, 'ie15, линии'),
    (Path('/home/azizz/Yandex.Disk/ie15/README.md'), 275, 277, 'ie15, конфиг линии'),
    (Path('/home/azizz/Yandex.Disk/mc-7401/README.md'), 51, 58, 'mc-7401, подключение по ДКС'),
    (Path('/home/azizz/Yandex.Disk/mc-7401/README.md'), 153, 160, 'mc-7401, наборы ввода'),
    (Path('/home/azizz/Yandex.Disk/mc-7401/README.md'), 175, 187, 'mc-7401, настройки'),
    (Path('/home/azizz/Yandex.Disk/re-siprod/README.md'), 1, 23, 're-siprod, назначение'),
    (Path('/home/azizz/Yandex.Disk/besm6-new/m20/simh/m20_cpu.c'), 13, 13, 'besm6-new, M-220 контекст'),
]

out = []
out.append('EVIDENCE.txt - дословные строки из источников.\n')
out.append('Формат: номер строки, затем исходная строка файла без изменений.\n')
out.append('Все пути абсолютные; readonly-доступ.\n\n')

for path, start, end, title in RANGES:
    # split('\n') only: splitlines() would also split on form feeds present in the plan.
    lines = path.read_text(encoding='utf-8', errors='replace').split('\n')
    out.append('=' * 100 + '\n')
    out.append(f'=== {title}\n=== {path} : {start}-{end}\n')
    for n in range(start, min(end, len(lines)) + 1):
        out.append(f'{n}: {lines[n-1]}\n')
    out.append('\n')

OUT.write_text(''.join(out), encoding='utf-8')
print(f'written {OUT} ({OUT.stat().st_size} bytes)')
