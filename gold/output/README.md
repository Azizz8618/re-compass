# Эталонные выводы по программам Северова

Корректные выводы программ Павла Северова (NIS GIDROPROEKT), полученные на восстановленном стеке Pascal-Монитор 15.1 + МАРС-6 + `COMTUP`/`SERVIS`. Все файлы - полный stdout `dispak`,включая листинг компиляции и печать монитора; `stderr` пуст.

| Файл | Что запускалось | Результат | md5 |
|---|---|---|---|
| `deck01-servis-original.out` | подлинные 41 строка деки `ПPOCTPAHCTBA HИCA` через front-end `src/servis_front.pas`; системные карты `*CMP`/`*SERVIS` пропускаются | 17 областей, 6 `ВОССТАНОВЛЕНИЕ`, `EXN=0`, `КОНЕЦ ЗАДАЧИ` | `113f7124…` |
| `deck01-servis-adapted.out` | та же дека с заменой системных карт на вызов SERVIS | 17 областей, `EXN=0` | `6385bb58…` |
| `deck01-servis-extra-ops.out` | SERVIS-операторы из строк 456-458, 593-594, 986-988 | 13 освобождений, 13 очисток, 3 сброса журнала, `EXN=0` | `4b66f84d…` |
| `deck02-ttc-schema.out` | схема `CX-CK0` из деки 2 (`*CMP:CXEMA CKЛAДA`), порт `TTC` | 2 типа, 8 записей, 13 наборов, 79 `PUTD`, `EXN=0` | `7b1df63c…` |
| `deck03-mad-output.out` | дека 3, полный MAD-цикл расширенного интерпретатора | поиски, `BЗЯTЬ`/`BЫДATЬ`, `ECЛИ COC`, `K;`, `KOHEЦ`, `EXN=0` | `55cde2a0…` |
| `deck08-mad-unload.out` | дека 8, выгрузка `CXE-AM` MAD-циклом | списки записей и ключей, `EXN=0` | `ca469fe0…` |
| `deck09-mad-unload.out` | дека 9, выгрузка `CXE-ПЛ` MAD-циклом | списки записей и ключей, `EXN=0` | `092be929…` |
| `deck04-schema-am.out` | схема `CX-AM0` из деки 4, расширенный порт `TTC` | 1 тип, 11 записей, 13 наборов, 25 `PUTD`, `EXN=0` | `cff02300…` |
| `deck05-fortran-startup.out` | дека 5 `CTAPT`, Fortran-стартап; оригинальный текст 49 строк не изменён, добавлены `PROGRAM CTAPT`, заглушки heads и подпрограмм | проход `ENTRY CK/AM/ЗT`, `BЫX`/`KOH`, `STOP`, `КОНЕЦ ЗАДАЧИ`; `EXN` не проверяется (Fortran) | `cf705582…` |
| `deck10-schema-zat.out` | схема `CX-ЗT0` из деки 10, расширенный порт `TTC` | 2 типа, 16 записей, 19 наборов, 37 `PUTD`, `EXN=0` | `da988f9d…` |
| `deck12-skmon.out` | дека 12-14, программа `SKLMON` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `2c75095c` |
| `deck12-skl-otd.out` | дека 12-14, программа `SKLOTD` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `6227ef3d` |
| `deck12-skl-car.out` | дека 12-14, программа `SKLCAR` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `69d152bb` |
| `deck12-skl-otc.out` | дека 12-14, программа `SKLOTC` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `0402b22d` |
| `deck13-amhed.out` | дека 12-14, программа `AMOHED` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `35e5b3ba` |
| `deck13-ammon.out` | дека 12-14, программа `AMOMON` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `db1e9ad7` |
| `deck13-amo-otd.out` | дека 12-14, программа `AMOOTD` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `7c321308` |
| `deck13-amo-car.out` | дека 12-14, программа `AMOCAR` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `c6a453cc` |
| `deck13-amo-otc.out` | дека 12-14, программа `AMOOTC` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `18777a66` |
| `deck13-amgru.out` | дека 12-14, программа `AMOGRU` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `48461e5f` |
| `deck14-zathed.out` | дека 12-14, программа `ZATHED` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `d1b53c1d` |
| `deck14-zatmon.out` | дека 12-14, программа `ZATMON` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `9c1549d0` |
| `deck14-zat-otd.out` | дека 12-14, программа `ZATOTD` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `5832b261` |
| `deck14-zatcof.out` | дека 12-14, программа `ZATCOF` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `14b94e70` |
| `deck14-zatzat.out` | дека 12-14, программа `ZATZAT` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `03d1e540` |
| `deck14-zatnak.out` | дека 12-14, программа `ZATNAK` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `2b117828` |
| `deck14-zatrte.out` | дека 12-14, программа `ZATRTE` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `6b966a20` |
| `deck14-zattab.out` | дека 12-14, программа `ZATTAB` через MADX зоны 3370 | `MAD FULL EX=0`, пустой stderr, `КОНЕЦ ЗАДАЧИ` | `f32fef43` |
| `deck06-07-11-genmad.out` | загрузчики дек 6, 7, 11 и MAD-деки 3/8/9, порт `GEN`/`MAD` | 26 форматов, 102 блока, 110 `PUTD`, 19 справочников, 4 MAD-запроса, `GEN EX=0`, `MAD EX=0` | `b7286a0b…` |
| `yam-predtgen.out` | 13 операций ЯМД из gold, порт `TPREDT` | `PLACE/FIRST/NEXT/BYKEY/PREV/GET/MODIF/LAST/REMOVE/INSERT/BDGET/BDPUT`, `EXN=0` | `246e0dc9…` |
| `raznoe-shtamp-ns0.out` | подпрограмма `SHTAMP` из `raznoe.txt:52-116`, `NS=0` | 44 координаты совпали с расчётом | `67122452…` |
| `raznoe-shtamp-ns1.out` | та же подпрограмма, `NS=1` | 58 координат совпали с расчётом | `cd2aae07…` |

Соответствующие деки и эталоны лежат в `tests/` (`original_deck_front.b6`, `gold_servis.b6`, `gold_servis_other.b6`, `ttc15.b6`, `genmad.b6`, `predtgen.b6`, `gold_shtamp*.b6`). Исходные тексты - в корне `gold/`.

Ограничения: файлы отражают восстановленное поведение, а не дословный вывод исторического монитора НИС Гидропроект (его текст и паспорт недоступны). Для `deck01-servis-original.out` в колонку 1 входных карт добавлен один пробел, чтобы монитор не перехватывал системные карты; SERVIS-операторы не изменялись.
