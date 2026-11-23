# W3: порт TSSDML на Паскаль-Монитор 15.1 и DML(TRUE) - финальное состояние

Scratch: `/home/azizz/.local/share/vifm/Trash/tss-w3-dml/`.
Репозиторий `~/Yandex.Disk/re-compass` не изменялся: ни одной записи, коммита
или push. Все прогоны `dispak` велись с `--path=<scratch>/disks`; оригиналы
`~/.besm6`, `/usr/local/share/besm6` и `tss-chain/floppy` не трогались.

## 1. Адрес сборки и зонный контроль (факт - главное)

Ошибка адреса из interim-отчёта исправлена: `TSSDML` **собран в зону 3260₈**
(дека `tssdml_build.b6`: `*perso:403260`, `*to perso:403260`), а не в 2570₈.
Итоговая последовательность на одной чистой копии 2348:

1. `tests/comtup_build.b6` - COMTUP в **2570**, `ДЛИНА LIBRARY 032 ЗОН`;
2. `tests/ucompas_build.b6` - UCOMPAS в **3350**, `ДЛИНА LIBRARY 003 ЗОН`;
3. `tssdml_build.b6` - TSSDML в **3260**, `ДЛИНА LIBRARY 003 ЗОН`.

Все сборки: exit 0, stderr пуст, **0 строк `******`**, баннер
`PASCAL COMPILER 15.1 (28.10.26)`. Лог финальной сборки:
`logs/final-inlinegen-build.run`.

`python3 tools/check_zone_changes.py <scratch>/2348 /usr/local/share/besm6/2348`
- **exit 0, `зонный контроль: PASS`, 0 `UNEXPECTED`**, изменено 32 зоны только
в разрешённых диапазонах: 2570..2637 (COMTUP), 3250..3334 (TSSDML),
3350..3360 (UCOMPAS). Результат: `artifacts/zone-check-final.txt`. Зона 2560
(GOSTLIB) не тронута.

Каталоги проверены `besmtool view`: 2570 - `COMTUP` с 18 входами, 3260 -
`TSSDML` с входом `DML`, 3350 - `UCOMPAS` с 15 входами. Ни один каталог не
перезаписан. Повторные `tests/ucompas_test.b6` (`DONE EXN=0`, `CGЕТ R=3072`,
`AFTER PUT R=4096`) и `tests/kompas_suite.b6` (`T08 BDKEY R=3072`,
`T10 PIC NC=0 NA=16`) прошли с exit 0, пустым stderr и 0 `******`; отличия от
эталонов только в дате баннера 23.11.26 -> 24.11.26. Логи:
`logs/final2-ucompas-test.run`, `logs/final2-kompas-suite.run`.

## 2. Порт и DML(TRUE) (факт)

`tssdml.pas` (295 строк) - диалект 15.1: `(*...*)`, строки ≤72 байт, без
подчёркиваний, инлайнированы `TYPEM`, `TYPEMI`, `TSLANG`, `TROCH`, `TTABCX`,
`TYPPIC`, `TEKOP`, `TRN`, `NAM`, `PUTEOL/PUTALF/PUTINT/PUTPOL`; нет
`Addr/INC/ASSIGN/CLOSE/ERASE/HALT`; `^` заменён на `@`. Таблица `SLANGM`
встроена целиком (100 терминов) в `SINTB`.

`DML(TRUE)` читает буфер из `BDVECT[139..]` в локальную копию `BUF.M`,
разбирает 6-символьные лексемы через `SINTB`/`DM1`/`DM2`/`POSHAG` и вызывает
готовые входы COMTUP: `TPCMPIN1(op+29*256)`, `TPCMPP1`, `TPCMP1I`. COMTUP не
переписывался. Покрыты PLACE, FIRST, NEXT, BYKEY, PREV, GET, MODIF, LAST,
REMOVE, INSERT, BDGET, BDPUT и модификатор `БД-KЛЮ` - 13 операций в деке
`dmlall13.b6` с загрузкой `*perso:412570`, `*perso:413350,cont`,
`*perso:413260,cont`.

## 3. Эксперименты со стеком (факт)

1. **Инлайнинг `GenOp`** в `DML`/`DM1` (убрал один фрейм вызова, исходник
   `src/tssdml_inlinegen.pas`, дека `tests/tssdml_inlinegen_3260.b6`): сборка
   0 диагностик, но `dmlall13.b6` по-прежнему даёт
   `STACK OVERRANGE. LINЕ 146` на втором `DML(TRUE)`. Логи:
   `logs/inlinegen_build.run`, `logs/final-dml13.run`. Гипотеза не подтвердилась.
2. **Пакетный вызов** `DML(TRUE)` со всеми 19 лексемами 13 операций в `BUF.M`
   (`src/batch13.pas`, `tests/batch13_inline_buf.b6`): дек компилируется с
   0 диагностик, stderr пуст, но во время единственного `DML` получаем
   `ОVЕRАNGЕ IN 81` / `STACK LЕNGТН` по main-программе. Лог
   `logs/batch13g.run`. Гипотеза не подтвердилась.
3. Пробовались также варианты без локальных переменных в `SINTB`/`NextTok`
   (`logs/nolocals*_*.run`): сборка даёт или 2 диагностики (`FOR` требует
   простую переменную цикла), или стековая ошибка сохраняется.

## 4. Точный stopping point (факт)

Полный 13-шаговый прогон через `DML(TRUE)` **не зафиксирован**. По финальному
состоянию (модуль с инлайненным `GenOp` в 3260): `dmlall13.b6` exits 0,
stderr пуст, 0 `******`, печатает `DМL РLАСЕ ЕХN=0 ВDЕRRN=0`, затем на втором
вызове `DML(TRUE)` выдаёт `STACK OVERRANGE. LINЕ 146` / `STACK IS SПОILЕD`.
Лог: `logs/final-dml13.run` (и `logs/nolocals2_full2.run` для предыдущей версии).

Контроль с теми же слотами BDVECT и MARS-схемой, но с прямыми `TPCMPIN1`
(`tests/direct13_3260.b6`), проходит все 13 шагов: первые 12 с `EXN=0`,
`BDERRN=0`, последний БД-ключевой GET даёт `EXN=8` из-за отсутствующих данных
(лог `logs/direct13_3260.run`). Два `DML(TRUE)` без MARS-схемы проходят
(`logs/twomin_loc.run`: `ONE 0`, `TWO 0`). Значит MARS-схема и слоты исправны;
дефект именно в стеке при повторном входе в `SINTB`/`DML` после `pasbd`.

Гипотеза (не проверена):STACK Pascal-Monitor не восстанавливается после
`pasbd` при вызове через `DML`;требует большего стека или переноса разбора в
main-программу. W5b может адаптироваться под пакетный вызов, но и он сейчас
упирается в тот же предел.

## 5. Артефакты и воспроизведение

`tssdml.pas`, `tssdml_build.b6`, `dmlall13.b6`, `REPORT.md`, `run.sh`, деки и
логи в `tests/`, `logs/`, md5-манифест в `artifacts/`. `bash run.sh` делает
чистую копию дисков, три сборки, прогон деки и зонный контроль.
