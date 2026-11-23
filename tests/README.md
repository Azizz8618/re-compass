# Контрольные примеры

## mars_smoke: дымовой тест МАРС из Pascal

Проверенный прогон 23.11.2026. Демонстрирует вызов МАРС из Pascal: `PASACD`, `PASSETAR`, `NEWD`, `OPEND`, `PUTD`, `GETD`, `MODD`, `DELD` и итераторы `LAST`/`PREV`.

- `mars_smoke.b6` - дека, md5 `ecd321d1da81723f1a2a5770562551f9`.
- `mars_smoke.expected.txt` - эталонный вывод, md5 `c035b5f940c9eaa4b0f157fa394f4510`.

Воспроизведение:

```sh
mkdir -p /tmp/.private/azizz/re-compass-run
cp ~/.besm6/{2048,2053,2099,2148,2348} /tmp/.private/azizz/re-compass-run/
cp tests/mars_smoke.b6 /tmp/.private/azizz/re-compass-run/
cd /tmp/.private/azizz/re-compass-run
dispak --path=. -p mars_smoke.b6 > output.run 2> output.err
diff -u tests/mars_smoke.expected.txt output.run
```

Все образы - рабочие копии. Оригинальные `/usr/local/share/besm6/*` и `~/.besm6/*` не изменяются. Запись на тома (`*to perso`) в тесте не производится.

### Критичные условия

| Условие | Что ломается без него |
|---|---|
| образ `2053` в `--path` | `НЕТ СТПАСП` |
| образ `2099` в `--path` | `disk_open: no 2099 image found`, ошибка загрузки супервизора |
| `лен 40(2048-630)^` | `ОШ.В ИНФ.СЛ.ЭКСТ`, код МАРС не загружен |
| `*perso:412570` | `ОТСУТСТВУЕТ Р/6А`, нет `PASACD`/`PASSETAR`/`PAIB` |
| `лен 41(2348)^` | том с зоной 2570 не смонтирован |
| `*call ficmemory`, `*call *pascal`, `*execute` | стандартный каркас компиляции |

Карта `*stand` оставлена в деке. В текущей среде баннер компилятора остаётся `PASCAL COMPILER 15.1 (28.10.26)` и при её отсутствии, поэтому её решающее значение для этого образа не подтверждено.

`MODD` принимает `array [1..4] of integer`, но не `packed array [1..24] of char`: попытка передать строку даёт ошибку компиляции 33 «НЕДОПУСТ ТИПЫ ПРИ ПРИСВАИВАНИИ».

### Особенность инструмента

`dispak -o file` без `-x` не создаёт файл; полный вывод пишется в stdout. С `-x -o` файл создаётся, но не содержит `КОНЕЦ ЗАДАЧИ` и строку `*74`. Поэтому эталон сохранён перенаправлением stdout.

### Результат

Вывод программы содержит четыре исходные записи, результат поиска по ключу, значения после `MODD` (`111111 222222 333333 444444`) и проверку удаления `DELD` повторным проходом `LAST`/`PREV`. Кодов ошибок МАРС из `sources/mars/errors.md` нет. Два последовательных прогона дали байтово идентичный вывод.

`find` после `DELD` вернул ключ предыдущей записи, а не `zero`. Гипотеза: микрокоманда оставляет в `bdvect[31]` ближайший ключ. Само удаление подтверждено отдельным проходом.

## comtup_build: проверка оснастки сборки

`comtup_build.b6` собирает `src/comtup.stub.pas` (17 заглушек) в PERSO-библиотеку зоны `2570₈`; `comtup_test.b6` вызывает все 17 внешних имён. Эталоны: `comtup_build.expected.txt`, `comtup_test.expected.txt`, `comtup30_limit.expected.txt`.

**Внимание: дека открывает 2348 на запись (`лен 40(2348-wr)^`)**. Запускать только на рабочей копии:

```sh
SCRATCH=/tmp/.private/azizz/comtup-check
mkdir -p "$SCRATCH/disks"
cp ~/.besm6/{2048,2053,2099,2148,2348} "$SCRATCH/disks/"
cp ~/Yandex.Disk/dispak/tests/arfalib/2196 "$SCRATCH/disks/"
cp "$SCRATCH/disks/2348" "$SCRATCH/disks/2348.orig.bak"
cd "$SCRATCH/disks"
dispak --path=. -p <путь-к-репозиторию>/tests/comtup_build.b6 > build.run 2> build.err
dispak --path=. -p <путь-к-репозиторию>/tests/comtup_test.b6 > test.run 2> test.err
```

Проверка каталога рабочей копии требует `BESM6_PATH=.`. Полные criteria и результаты: `docs/BUILD-VERIFICATION.md`.

## comtup_final: рабочий модуль

`comtup_final_build.b6` собирает `src/comtup.pas` (18 входов), `comtup_final_test.b6` проверяет разрешение всех внешних имён, `comtup_state_test.b6` проверяет COMMON-состояние, адрес переменной и `*BDERRN*`. Эталоны: `comtup_final_build.expected.txt`, `comtup_final_test.expected.txt`, `comtup_state_test.expected.txt`.

Дека сборки открывает 2348 на запись (`лен 40(2348-wr)^`) и увеличивает библиотеку до `032 ЗОН`. Запускать только на рабочей копии с резервом, как описано выше. Результаты и оговорки: `docs/COMTUP-IMPLEMENTATION.md`.

## cgetbdkey: фикстура и интеграционный тест

`cgetbdkey_fixture.b6` создаёт запись `kbd001` с бд-ключом `6000₈ = 3072`. `cgetbdkey.b6` воспроизводит каноническую последовательность `UCOMPAS.PAS:103-111` на процедурах `COMTUP` и проверяет, что `R` стал равен бд-ключу. Эталоны: `cgetbdkey_fixture.expected.txt`, `cgetbdkey.expected.txt`.

`cgetbdkey_single.b6` - тот же тест с однодисковым монтированием `лен 40(2348-630)^` + `лен 41(2348)^`. Зона `630₈` на 2348 идентична зоне 630 на 2048, поэтому второй том не нужен. `cgetbdkey_external.b6` - исходный вариант с вызовом внешнего `COMTUP`; он даёт `R = 0`, потому что фикстура создана в другой деке. Рабочий вариант - `cgetbdkey_external_fixed.b6`: фикстура и запрос в одном процессе, `SSBF5` инициализируется только при `BDVECT[36] = 0`. Результат: `R = 3072`, `BDERRN = 0`, `EXN = 0`.

`cputbdkey_put.b6` проверяет op 89 (`CPutBdKey`): старый бд-ключ `6000₈`, новый `10000₈`. После `TPCMPIN1(7513)` слот `[29]` содержит `10000₈`, последующее чтение через `TPCMPIN1(7514)` даёт `R = 4096`, `BDERRN = 0`, `EXN = 0`.

## gold_shtamp: контрольный пример из `gold/`

`gold_shtamp.b6` и `gold_shtamp_v.b6` - рабочие деки на основе подлинного текста `SHTAMP` из `gold/…raznoe.txt:52-116` с добавленной главной программой и заглушками `GRID`/`MOVE`. Проверяют кодировку, формат деки и Дубнинский ФОРТРАН-компилятор. `NS=0`: 44 точки, `NS=1`: 58 точек; все координаты совпали с расчётом по константам исходника. Это не тест КОМПАС. Подробности: `docs/GOLD-MATERIALS.md`, `docs/GOLD-RUN-REPORT.md`.

## kompas_suite: интеграционный тест уровня СУБД

`kompas_suite.b6` проверяет 10 операций через внешние точки `COMTUP`: инициализацию, `CPlace`, `CFindFirst/Next/ByKey/Preceding`, `CGetKnot`, `CReplace`, `CGetBdKey`, `CPutBdKey`, `ITLEN`. Эталон `kompas_suite.expected.txt` байтово стабилен. Запуск: `bash tools/run_kompas_suite.sh` (скрипт сам собирает `COMTUP` на рабочей копии 2348). Подробности: `docs/KOMPAS-SUITE.md`.

`aremars.b6` - импорт области `ZPROC.ARE` в МАРС: 13 ключей, `PUTD`, затем `FIND`/`GETD` с пословным сравнением. Эталон `aremars.expected.txt`, ключи `aremars_keys.json`. Генератор деки: `tools/are_to_mars.py`.

`adatars.b6` - импорт 40 ключей из 14-страничной `ADA.ARE`, генератор `tools/are_to_mars_multi.py`, эталон `adatars.expected.txt`, ключи `adatars_keys.json`. Операции разнесены по пяти парам процедур из-за лимита компилятора на размер блока. Подробности: `docs/ARE-DATA.md`.

`bpmars.b6` (25 ключей `BPEMEH.ARE`) и `scmars.b6` (40 ключей `SC.ARE`) - продолжение импорта служебных областей того же выпуска, с эталонами и файлами ключей. Подробности: `docs/ARE-DATA.md`.

`servis_build.b6` и `servis_ops.b6` - сборка модуля `src/servis.pas` и тест из 11 операторов SERVIS с эталоном `servis_ops.expected.txt`. Подробности: `docs/SERVIS-PORT.md`.

`servis_build4.b6` и `servis_ops4.b6` - расширенный тест этапа 4: 11 областей, дубли, журналы, ADMIN/ADA, эталон `servis_ops4.expected.txt`. Подробности: `docs/SERVIS-STAGE4.md`.

`ucompas_build.b6` и `ucompas_test.b6` - порт верхнего слоя API COMPASS. Сначала собирается COMTUP (`comtup_final_build.b6`, зона 2570), затем UCOMPAS в свободную зону 3350; `2560₈` (GOSTLIB) не трогается. Тест проверяет `COpen`, `CClose`, `CGetBdK`, `CPutBdK`: `R=3072`, после PUT `R=4096`, `EXN=0`. Подробности: `docs/UCOMPAS-PORT.md`.

`pic_ops_66_67_76_77.b6` - проверка четырёх PIC-операций через `comtup.pas`; `chunk_w1/w2/reader.b6` - реестр кусков для логической области 1750 зон.

`deck04-schema-am.b6` и `deck10-schema-zat.b6` - схемы 4 и 10 через расширенный `src/ttc15_ext.pas`; `deck05-fortran-startup.b6` - Fortran-стартап с заглушками. Эталоны - одноимённые `.expected.txt` и файлы в `gold/output/`.

`tsspr-linked-ucompas.b6` - линковка `TSSPPR` с `COMTUP` (2570) и `UCOMPAS` (3350), `ОТСУТСТВУЕТ=0`; исходник `src/tsspr-linked.pas`. Сборка библиотек в одной копии диска обязательна: `comtup_final_build.b6`, затем `ucompas_build.b6`, без восстановления между ними. Подробности: `docs/TSS-W1-LINKAGE.md`.

`tsspr-v12-linked.b6` - объединённая версия с диагностикой `ERROUT`, `SLANGM` на 100 операторов и рабочим `dml`; `tsspr-v12-probe.b6` - автономная проверка печати кодов 40/705 и `DML OP=4`. Исходники: `src/tsspr-v12-linked.pas`, `src/tsspr-v12-probe.pas`. Подробности: `docs/TSS-W2-GUI.md`.

`tests/severov-apps/*.b6` - 18 дек прикладных программ дек 12-14, сгенерированных из `src/generated/*.pas`; 345 вызовов `DMLCALL` вместо пар `&&...&&`. Подключают `COMTUP/SERVIS` (2570), `UCOMPAS` (3350), `TSSDML` (3260) и `TSSPPR` (3300). Пока ожидают готовой библиотеки 3300 и исправления повторного входа в `DML`. Генератор: `tools/severov/extract_and_gen.py`, проверка: `tools/severov/check_decks.sh`. Подробности: `docs/TSS-W5A-PREP.md`.

`tests/tsspr3300_build.b6` собирает `src/tsspr-v12-linked.pas` в зону 3300 (`036 ЗОН`, фактические зоны 3304..3341). `tests/tssdml_build.b6` собирает `src/tssdml.pas` в зону 3260; `tests/direct13_3260.b6` проверяет 13 операций прямыми вызовами `TPCMPIN1` (эталон совпадает); `tests/dmlall13.b6` фиксирует известный отказ `STACK OVERRANGE` на втором `DML(TRUE)`. Сборка библиотек в одной копии диска: `comtup_final_build.b6`, `ucompas_build.b6`, `tssdml_build.b6`. Подробности: `docs/TSS-W3-DML.md`.

`gold_servis.b6` и `gold_servis_other.b6` - адаптированные подлинные SERVIS-операторы из `gold/`, с эталонами. `gold_servis.b6` создаёт 17 областей первой дека `\ПPOCTPAHCTBA HИCA`. Подробности: `docs/GOLD-SERVIS-RUN.md`.

`predtgen.b6` и `predtgen.expected.txt` - порт предтранслятора ЯМД: 13 операций (PLACE, FIRST, NEXT, BYKEY, PREV, GET, MODIF, LAST, REMOVE, INSERT, BDGET/BDPUT), `EXN=0`. Подробности: `docs/PREDT-PORT.md`.

`ttc15.b6` - схема CX-CK0 (2 типа, 8 записей, 13 наборов, 79 `PUTD`); `genmad.b6` - 26 форматов, 102 блока, 110 `PUTD` и MAD-запросы; `original_deck_front.b6` - подлинные 41 строка деки Северова с пропуском системных карт. Эталоны - одноимённые `.expected.txt`. Подробности: `docs/TTC-PORT.md`, `docs/GEN-MAD-PORT.md`, `docs/ORIGINAL-GOLD-DECK.md`.

Обе деки работают на рабочих копиях дисков. Перед каждым прогоном `newd` нужно восстанавливать образ 2048, иначе МАРС выдаёт `10 НЕТ ИМЕНИ`. Подробности: `docs/CGETBDKEY-TEST.md`, `docs/DISK-2348.md`.
