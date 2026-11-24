# W3b: поиск первопричины `STACK OVERRANGE` в `DML(TRUE)`

Scratch: `/home/azizz/.local/share/vifm/Trash/tss-w3b-stack/`.
Репозиторий `~/Yandex.Disk/re-compass` не изменялся: ни одной записи, коммита
или push. Оригиналы дисков не трогались, `dispak` запускался только с
`--path=<scratch>/disks`. ГOSTLIB в 2560 не тронута.

## 1. Подготовка (факт)

Диски скопированы из `tss-w3-dml/disks` (там уже собраны COMTUP в 2570,
UCOMPAS в 3350, TSSDML в 3260). Созданы `backup/` и md5-манифест
`artifacts/md5-manifest.txt`. Базовый прогон `tests/dmlall13.b6`
воспроизвёл отказ: exit 0, stderr пуст, 0 `******`, первая строка
`DML PLACE EXN=0 BDERRN=0`, затем `STACK OVERRANGE. LINE 146` /
`STACK IS SPOILED` (`logs/baseline.run`).

## 2. Проверенные гипотезы (факт, все отрицательные)

Каждая гипотеза проверялась прогоном; колоды и логи сохранены в `tests/`, `logs/`.

| Гипотеза | Дека / лог | Результат |
|---|---|---|
| Небольшая рабочая область: `ОЗУ 64^` или без `ОЗУ` | `exp_mem64`, `exp_memnone` | отказ сохраняется |
| Порядок `*perso`: TSSDML первым | `exp_order`, `exp_ord_*` | либо `ОТСУТСТВУЕТ DML`, либо отказ сохраняется |
| Сброс `*BDERRN*` перед каждым вызовом | `exp_reset` | отказ сохраняется |
| Вызов `EXN`/`ITLEN`/`SSBF5` перед `DML` | `exp_exn_pre`, `exp_itlen_pre`, `exp_ssbf_pre` | отказ сохраняется |
| Объявление `TPCMPIN1` как `FORTRAN` вместо `EXTERNAL` в модуле | `tssdml_fortran_build` | отказ сохраняется |
| Инлайнинг `GenOp` (убрать один фрейм) | `tssdml_inlinegen_3260.b6` | отказ сохраняется |
| Пакетный вызов: все 19 лексем 13 операций в `BUF.M`, один `DML(TRUE)` | `batch13_inline_buf.b6`, `logs/batch13g.run` | `ОVERАNGЕ IN 81`, `STACK LENGTH` |
| Удаление локальных переменных из `SINTB`/`NextTok` | `nolocals*_*.run` | или 2 диагностики (`FOR` требует простую переменную цикла), или отказ |
| Перенос MARS-схемы (`PASACD/newd/opend/putd/SSBF5`) в отдельный экспортный `Setup` модуля | `tssdml_setup_build.b6`, `logs/setup_run.run` | отказ сохраняется |
| Конфликт буферных слотов BDVECT: 139 -> 120 | `tssdml_slot120_build.b6` | отказ сохраняется |
| Отложенный вызов: `DML` только кодирует слово в `BDVECT[157]`, `TPCMPIN1` вызывается вызывающей программой | `tssdml_defer_build.b6`, `dml13_defer.b6` | отказ сохраняется |

Дополнительно проверено: два `DML(TRUE)` **без** MARS-схемы проходят
(`logs/twomin_loc.run`, `ONE 0`, `TWO 0`); 13 прямых `TPCMPIN1` с той же
MARS-схемой и слотами проходят (`logs/final-direct13.run`: exit 0, stderr пуст,
0 `******`, 12 шагов `EXN=0`, последний БД-ключевой GET `EXN=8` из-за
отсутствующих данных). Следовательно ни MARS-схема, ни слоты, ни сам `pasbd`
по отдельности не являются причиной. Отказ возникает только при сочетании
«MARS-схема + повторный вход в разбор `DML`».

## 3. Точный stopping point (факт)

После всех экспериментов в 3260 пересобрана исходная рабочая версия
`tssdml.pas` из W3 (0 диагностик, лог `logs/restore_build.run`). Её базовый
прогон снова даёт `STACK OVERRANGE. LINE 146` (`logs/restore_baseline.run`,
строка 146 - вход в `SINTB`). Полный 13-шаговый прогон через `DML(TRUE)`
**не получен**. Критерий W3b не достигнут; исправление в текущем стеке
Паскаль-Монитора 15.1 не найдено.

## 4. Гипотеза (не подтверждена)

Похоже, что MARS-вызов оставляет регистр/указатель, который Паскаль-Монитор
использует как границу стека, в состоянии, при котором второй вход в
процедуру с собственным фреймом (`SINTB` внутри `DML`) выходит за предел.
Увеличение `ОЗУ`, смена `*call`, сброс `BDERRN`, вызовы COMTUP перед `DML`
и уменьшение глубины вызововне дали эффекта. Прямой вызов `TPCMPIN1` из главной
программы работает, потому что не создаёт дополнительного фрейма разбора.

## 5. Минимальная адаптация DMLCALL (текст патча, репозиторий не трогался)

Поскольку проверенный путь - прямые вызовы `TPCMPIN1`, предлагается заменить
в `tools/severov/extract_and_gen.py` генерацию `DML(TRUE)` на генерацию
последовательности `TPCMPIN1` с теми же слотами BDVECT. В функции, формирующей
`dml` (строки 218-232 файла), вместо последних трёх строк:

```python
    dml.append('  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=\' \';')
    dml.append('  DML(TRUE)')
    dml.append('end;')
```

подставить:

```python
    dml.append('  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=\' \';')
    # W3b: DML(TRUE) ломает стек Паскаль-Монитора 15.1 после MARS-схемы.
    # Эмитируем проверенные слова COMTUP напрямую (как direct13_3260.b6).
    for word in SNIPPET_WORDS:            # таблица id -> PIC-слово
        dml.append('  TPCMPIN1(%d)' % word)
    dml.append('end;')
```

где `SNIPPET_WORDS` - отображение `id` сниппета в слово `op+29*256`
(PLACE 7425, FIRST 7428, NEXT 7436, BYKEY 7426, PREV 7437, GET 7440,
MODIF 7439, LAST 7435, REMOVE 7431, INSERT 7430; BDGET 7514, BDPUT 7513
требуют дополнительных `TPCMPP1`-прелюдий и `TPCMP1I` для слотов 22/24 по
образцу `src/predtgen.pas`). Это сохраняет рабочие входы COMTUP и обходит
дефектный повторный вход в `DML`. Патч не применялся.

## 6. Состояние диска и артефакты (факт)

`python3 tools/check_zone_changes.py <scratch>/2348 /usr/local/share/besm6/2348`
- **exit 0, `зонный контроль: PASS`, 0 `UNEXPECTED`**, изменено 33 зоны только
в разрешённых диапазонах (`artifacts/zone-check-final.txt`). Каталоги 2570
(COMTUP) и 3350 (UCOMPAS) целы: `ucompas_test.b6` (`DONE EXN=0`) и
`kompas_suite.b6` (`T10 PIC NC=0 NA=16`) прошли с exit 0, пустым stderr и
0 `******` (`logs/final-ucompas.run`, `logs/final-kompas.run`).

В scratch сохранены исходники (`src/`), колоды (`tests/`), логи (`logs/`),
md5-манифест и этот отчёт. `bash run.sh` в W3 остаётся воспроизведением
сборки 3260 и зонного контроля.
