# Конвейер сборки и запуска

Компилятор: Pascal-Монитор МС «Дубна», модуль `PASCOMPL`. Баннер штатного оверлея: `PASCAL COMPILER 15.0 (15.02.82)`. Баннер реконструированного: `PASCAL COMPILER 15.1 (28.10.26)`.

## Подготовка

```sh
export BESM6_PATH=$HOME/.besm6:/usr/local/share/besm6:$HOME/Yandex.Disk/simh/BESM6/MD/EC5061
make mars-check
```

Эталон `/usr/local/share/besm6/2348` не трогать. Рабочая копия - `~/.besm6/2348`.

## Дека ДИСПАК

```text
user 419999 зс5^
лен 40(2348)^
eeв1а3
*name
*call yesmemory
*perso:402570
*stand
*call *pascal
<Pascal-текст, фигурные скобки заменяются на _( _)>
*execute
*end file
``````
ЕКОНЕЦ
```

`*STAND` обязательна: без неё `*CALL *PASCAL` берёт штатный оверлей 15.0, игнорируя `PASCOMPL` из временной библиотеки. Для МАРС добавляют `лен 40(2048-630)^` (код МАРС) и используют `*perso:412570`, если 2348 на LU 41.

Готовый сценарий: `~/Yandex.Disk/pascal-re/tools/perso-run.sh program.pas --zone=2570`.

## Компиляция и запуск

```sh
dispak -p -o tests/mars_smoke.run tests/mars_smoke.b6
~/Yandex.Disk/pascal-re/tools/perso-run.sh tests/mars_smoke.pas --zone=2570
```

Вывод содержит печать монитора, листинг компилятора, `LINES STRUCTURE`, каталог модулей и вывод программы. Эталоны: `~/Yandex.Disk/dispak/tests/pascal-monitor/output.txt`, `~/Yandex.Disk/dispak/tests/arfalib/output.txt`.

## Запись модуля в библиотеку

В `arfalib-build.b6` после исходника стоит `*to perso:402570`. Монитор печатает `ДЛИНА LIBRARY <NNN> ЗОН` (восьмеричных, включая два зонных каталога). Перед записью сделать резервную копию тома.

## Сверка

```sh
besmtool view 2348 --start=1400 --length=2 --encoding=t
besmtool dump 2348 --start=1400 --length=<зон-2> --to-file=build/module.o
disbesm6 -a0 -e0 build/module.o > disasm/module.asm 2> disasm/module.err
cmp build/zone-roundtrip.bin gold/zone.bin
```

Критерии приёмки по `dispak/tests/run-test.py`: сравнение с эталоном через `difflib.unified_diff`, символ `#` в эталоне - wildcard. Каждый прогон начинается с чистой копии тома.

## Типичные ловушки

- Строки деки длиннее 72 символов обрезаются; `external`-объявления теряют хвост и компилятор выдаёт ложные ошибки 84/12/52.
- Глобальные переменные объектного модуля ложатся поверх данных вызывающей программы; состояние хранить в локальных переменных.
- `PASBDI` без инициализации `*BDVECT*` падает «ЗАТЕРТО СПО».
- Карты `*PERSO:LUZZZZ` принимают восьмеричные номера зон; `besmtool` - десятичные.
- Ошибки компилятора описаны в `~/Yandex.Disk/pascal-re/errors.txt`, ошибки МАРС - в `besm6.github.io/sources/mars/errors.md`.
