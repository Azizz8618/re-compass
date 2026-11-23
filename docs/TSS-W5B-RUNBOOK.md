# W5b: прогон 18 прикладных программ

Порядок завершающего этапа плана `docs/TSS-PORT-PLAN.md`. Выполняется после приёмки W3 (TSSDML в зоне 3260).

## 1. Подготовка диска

Рабочая копия в отдельном scratch (оригиналы `~/.besm6/*` и `/usr/local/share/besm6/*` не трогать), `backup/`, md5-манифест. В одной копии диска 2348 последовательно собрать:

| Библиотека | Зона | Дека сборки | Источник |
|---|---|---|---|
| `COMTUP` + `SERVIS` | 2570 | `tests/comtup_final_build.b6` | `src/comtup.pas`, `src/servis.pas` |
| `UCOMPAS` | 3350 | `tests/ucompas_build.b6` | `src/ucompas.pas` |
| `TSSDML` | 3260 | `tests/tssdml_build.b6` | `src/tssdml.pas` |
| `TSSPPR` | 3300 | `tests/tsspr3300_build.b6` | `src/tsspr-v12-linked.pas` |

Не восстанавливать диск между сборками. Проверено из репозитория на свежих копиях: все четыре сборки дают 0 `******`, `ДЛИНА LIBRARY 036 ЗОН` для TSSPPR; фактические зоны 3264..3266 и 3304..3341, зонный контроль PASS с расширенным диапазоном 3250..3347. `2560₈` (GOSTLIB) не трогать. После каждой записи: `python3 tools/check_zone_changes.py <scratch>/2348`, только разрешённые зоны из `docs/ZONE-ALLOCATION.md`.

## 2. Пилоты

Три программы по одной из каждой деки, в порядке:

1. `SKLMON` (`tests/severov-apps/SKLMON.b6`)
2. `AMOHED` (`tests/severov-apps/AMOHED.b6`)
3. `ZATHED` (`tests/severov-apps/ZATHED.b6`)

Для каждого: `exit=0`, пустой stderr, баннер `PASCAL COMPILER 15.1 (28.10.26)`, ноль `******`, нет `ОТСУТСТВУЕТ` и `ЗАПРЕЩ.КОМАНДА`, `EXN=0`, `BDERRN=0`, `КОНЕЦ ЗАДАЧИ`. Диагностика W2 (`ОШИБКА n:`) допустима только если она предусмотрена текстом программы.

## 3. Остальные 15

Порядок из `docs/TSS-CHAIN.md`, раздел 5.2: `SKLOTD`, `SKLCAR`, `SKLOTC`, `AMOMON`, `AMOOTD`, `AMOCAR`, `AMOOTC`, `AMOGRU`, `ZATMON`, `ZATOTD`, `ZATCOF`, `ZATZAT`, `ZATNAK`, `ZATRTE`, `ZATTAB`.

Ожидаемые имена эталонов - колонка «Файл эталона» таблицы 5.2. Перед сравнением дата баннера нормализуется:

```sh
sed -E 's/[0-9]{2}\.[0-9]{2}\.26/DD.MM.26/g'
```

## 4. Фиксация результата

- Деки уже лежат в `tests/severov-apps/`, исходники в `src/generated/`.
- Эталоны: `tests/severov-apps/<NAME>.expected.txt` и `gold/output/deck12-*.out`, `deck13-*.out`, `deck14-*.out`.
- В `gold/output/README.md` добавить строки с md5 и фактическим числом строк.
- В `docs/REPRODUCE-SEVEROV-ALL.md` и `docs/STATUS.md` перевести дек 12-14 в состояние «воспроизведено» только по факту прогона.
- В `docs/REPRODUCE-SEVEROV.md` добавить итоговую таблицу 18 программ.

## 5. Известные blockers на входе

- W3/W3b: полный прогон 13 операций через `DML(TRUE)` падает с `STACK OVERRANGE` во втором вызове; 11 дополнительных гипотез не помогли (`docs/TSS-W3B-STACK.md`). Прямой вызов тех же 13 операций через `TPCMPIN1` проходит. Поскольку 198 уникальных прикладных сниппетов не покрываются таблицей 54 внутренних макросов `TSSPPR`, выбран путь переиспользования проверенного интерпретатора `src/genmad_full.pas` как внешнего входа `MADRUN` в зоне 3370.
- W4: не подтверждены 16 слов с `low=29`, опкод `7438`, представление полей `L`/`M` (`docs/PIC-SLOT-MAP.md`). При проявлении в прогоне фиксировать как расхождение, не закрывать молча.

## 6. Проверки перед коммитом

`make check`, `make mars-check`, `make smoke`, `bash tools/run_kompas_suite.sh`, зонный контроль, сверка md5 оригиналов. Коммит и push в `origin` и `sourcecraft` только после зелёных проверок.
