# Конвейер сборки и запуска

Компилятор: Pascal-Монитор МС «Дубна», модуль `PASCOMPL`. Баннер штатного оверлея: `PASCAL COMPILER 15.0 (15.02.82)`. Баннер реконструированного: `PASCAL COMPILER 15.1 (28.10.26)`.

## Подготовка

```sh
export BESM6_PATH=$HOME/.besm6:/usr/local/share/besm6:$HOME/Yandex.Disk/simh/BESM6/MD/EC5061
make mars-check
```

Эталон `/usr/local/share/besm6/2348` не трогать. Рабочая копия - `~/.besm6/2348`.

## Дека ДИСПАК

Проверенный вариант: `tests/mars_smoke.b6`.

```text
шифр 419900зс5^
лен 40(2048-630)^
лен 41(2348)^
ОЗУ 32^
еев1а3
*name
*call ficmemory
*perso:412570
*stand
*call *pascal
(*=p-,t-*)PROGRAM main (OUTPUT,bdvect);
<текст Pascal>
*execute
*end file
``````
еконец
```

Карты, проверенные снятием по одной:

- `лен 40(2048-630)^` - критична: без неё `ОШ.В ИНФ.СЛ.ЭКСТ`, код МАРС не загружен.
- `*perso:412570` - критична: без неё `ОТСУТСТВУЕТ Р/6А`, нет `PASACD`, `PASSETAR`, `PAIB`.
- `*stand` - в текущей среде баннер остаётся `PASCAL COMPILER 15.1 (28.10.26)` и без неё; карта сохранена для совместимости с правилами `pascal-re`.
- Образы `2053` и `2099` должны быть в `--path`: иначе `НЕТ СТПАСП` и `Error loading supervisor`.

`лен 40(2048-630)^` монтирует код МАРС с тома 2048, зона `630₈`. `*perso:402570` применяется, если 2348 смонтирован на LU 40. Готовый сценарий: `~/Yandex.Disk/pascal-re/tools/perso-run.sh program.pas --zone=2570`.

## Компиляция и запуск

```sh
mkdir -p /tmp/re-compass-run
cp ~/.besm6/{2048,2053,2099,2148,2348} /tmp/re-compass-run/
cp tests/mars_smoke.b6 /tmp/re-compass-run/
cd /tmp/re-compass-run
dispak --path=. -p mars_smoke.b6 > output.run 2> output.err
diff -u <путь-к-репозиторию>/tests/mars_smoke.expected.txt output.run
```

Вывод содержит печать монитора, листинг компилятора, каталог модулей и вывод программы. `dispak -o file` без `-x` не создаёт файл; с `-x -o` файл не содержит `КОНЕЦ ЗАДАЧИ` и `*74`. Полный вывод сохраняется перенаправлением stdout.

`MODD` принимает `array [1..4] of integer`, но не `packed array [1..24] of char`: строка даёт ошибку компиляции 33. Подробности и эталон: `tests/README.md`.

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
