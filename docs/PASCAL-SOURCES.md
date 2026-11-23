# Pascal-текст КОМПАС

Диалект: Turbo Pascal 5.0/7.0 Borland, MS-DOS, кодировка CP866. Признаки: `unit ... interface uses ... implementation`, `object(TObject)`, `constructor`, `virtual`, директивы `{$IFDEF}`, `{$A-}`, `{$L COMPASST.OBJ}`, ассемблерные вставки `asm mov ax,$BCDE int $12 end`. `override` не встречается, значит это TP7, не Delphi.

Полный перечень с путями внутри архива и размерами: `inventory/pascal-sources.tsv`.

## Два поколения исходников

**Классический Компас-РС** (`TURK.ARJ`, 1994): `COMFY.PAS` (определение данных), `TTC.PAS` (транслятор схем), `TSSDML.PAS` (язык манипулирования данными, 3142 строки), `TSERVIS.PAS` (работа с областями), `GEN.PAS`, `TPREDT.PAS` (предтранслятор), `TSSBAS.PAS` (SSBASE), `TSPIC.PAS` (микрокод), `COMTUP.PAS` (низкий уровень).

**«Новая (94г) версия»** (`SYS.ARJ`, `950112MX.ARJ`): `UCOMPIL.PAS` (компилятор встроенного языка), `UACTIONS.PAS` (операции ЯМД), `UCOMPAS.PAS` (API доступа к БД), `CMPSNO.PAS`/`UCMPSN.PAS` (модель данных), Turbo Vision-оболочка `STARTUP.PAS`, `EDITORS.PAS`, `CMPSW.PAS`.

Заголовок `TSSDML.PAS`: `{* СИСТЕМА КОМПАС All rights reserved. *}` / `{* МОДУЛЬ SSDML *}`.

## Что брать без изменений

Эти модули не обращаются к DOS и TSR напрямую:

| Модуль | Роль |
|---|---|
| `TYPES.PAS` | базовые типы, объектная модель |
| `UNIOBJ.PAS`, `UTEXT.PAS`, `COLLEC.PAS`, `OFSD.PAS` | универсальные объекты, текст, коллекции |
| `CMPSNO.PAS`, `UCMPSN.PAS` | ядро модели данных |
| `TSPIC.PAS`, `UNPIC.PAS` | структура PIC: `ALF6`, `LENLIT=383`, `LENOP=384` |
| `UACTIONS.PAS`, `UVARS.PAS`, `USUBPR.PAS` | операции и переменные ЯМД |
| `UCOMPIL.PAS` | компилятор выражений и форм |

Структура `PIC` полностью соответствует `MICROCOD.TXT` из `SYST.ARJ`: запись `typpic` с `alf6` и литералами 0..383. Это прямое подтверждение, что микрокод PC-версии совпадает с БЭСМ-описанием.

## Что подлежит замене

| Модуль | Проблема | Замена |
|---|---|---|
| `COMTUP.PAS` | 16 `EXTERNAL`-процедур, вызов TSR через `INT 12h` и DOS-файлы | реализовать те же сигнатуры через МАРС (`MARS-INTERFACE.md`) |
| `COMPASST.OBJ`, `COMPASST.ASM` | резидент PC, `BORLAND TURBO PASCAL ... INTERFACE TO COMPASS-tsr` | `NEWD/OPEND/PUTD/GETD/MODD/DELD`, `PASBDI`/`PASBD` |
| `UCOMPAS.PAS` | зашиты числовые коды PC-ядра: `TPCMPP1(36)`, `TPCMPP1(19712)`, `TPCMPP1(19456)`, `TPCMPIN1(7439)` | тонкая обёртка над новым `COMTUP` на операциях МАРС |
| `TSERVIS.PAS` | `PAROBL`, `novOBL`, `ustOBL`, `OCB` целиком на `COMTUP`, область - файл ОС | область - архив/зона МАРС-6 |
| `TSSBAS.PAS` | чтение/запись SSI через PC-слой | переписать операции над SSI |
| `STARTUP.PAS`, `EDITORS.PAS`, `CMPSW.PAS`, оверлеи | Turbo Vision, GUI, DOS | не переносить |

## Контракт нижнего уровня

`COMTUP.PAS` объявляет 16 внешних процедур:

```
SSBF5, SSREZK, TPCMPADR, TPCMPAD1, TPCMPP1, TPCMPIN1, TPCMPNNA, TPCMPL1,
AROP, APIC, EXN, ITLEN, APIC2, TCMPIN, TCMPINP, WPASRA, VPASR6
```

`UCOMPAS.PAS` показывает, как высокий уровень превращается в низкоуровневые коды: `COpen`, `CClose`, `CPlace`, `CReplace`, `CRemove`, `CFindFirst/Next/Preceding/End`, `CFindByKeyElement`, `CGetBdKey`, `CPutBdKey`, `CGetKnotByKey`, `CInclude/CExclude/CReinclude`, `CompassInstalled`.

Сохранив сигнатуры `COMTUP`, можно оставить верхние слои нетронутыми и заменить только реализацию.

## Ложная находка

`PASCAL.ARJ` (`PINT.P`, `PCOM.P`) - не Компас. Из `READ.ME`: «Pascal source of a public domain Pascal compiler and interpreter by Steven Pemberton and Martin Daniels». Это P4-компилятор без генератора кода БЭСМ-6. Использовать его как компилятор не следует; компилятор уже есть на 2348 в зоне 2570 (`PASCOMPL` 15.1).

## БЭСМ-специфика в данных, а не в синтаксисе

- `ALF6 = PACKED ARRAY[1..6] OF CHAR` - слово БЭСМ-6.
- `LENLIT=383`, `LENOP=384`, `LSSI=340`, `LENDESREC=8`.
- `MICROCOD.TXT`: «переменные, общие для МАРС-А и резидента», разделы «ОПЕРАЦИИ РЕЗИДЕНТА», `TIR`/`VARI`, `MSF`, `Interp`.
- `MARS.ASM` из `ASM.ARJ` - эмулятор МАРС на x86 (`INMARS`, `OP interpretation`), не исходник БЭСМ.

Прямого доказательства, что этот Pascal-текст предназначался для портирования на БЭСМ-6, в архиве нет. Связка «Компас-БЭСМ - МАРС-6 - Компас-РС» подтверждена документацией (`COMHELP`, `K1T1.TXT`, `K72.TXT`). Гипотеза о замене нижнего уровня опирается на архитектурный контракт, который текст задаёт через `COMTUP`/`COMPASST.OBJ`.
