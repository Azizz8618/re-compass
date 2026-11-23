# План воспроизведения задачи Северова

Документ описывает, как воспроизвести все проверенные результаты по декам Павла Северова (NIS GIDROPROEKT) на текущем стеке Pascal-Монитор 15.1 + МАРС-6 + `COMTUP`/`SERVIS`.

## 1. Что уже воспроизведено

| Ресурс | Результат | Эталон |
|---|---|---|
| первая дека `ПPOCTPAHCTBA HИCA` (строки 1-41) | 17 областей, 6 `ВОССТАНОВЛЕНИЕ`, `EXN=0` | `gold/output/deck01-servis-original.out` |
| та же дека с адаптацией системных карт | 17 областей, `EXN=0` | `gold/output/deck01-servis-adapted.out` |
| SERVIS-операторы из строк 456-458, 593-594, 986-988 | 13 освобождений, 13 очисток, 3 сброса журнала | `gold/output/deck01-servis-extra-ops.out` |
| дека 2 `CXEMA CKЛAДA` | 2 типа, 8 записей, 13 наборов, 79 `PUTD` | `gold/output/deck02-ttc-schema.out` |
| деки 6, 7, 11 и MAD-деки 3/8/9 | 26 форматов, 102 блока, 110 `PUTD`, 19 справочников | `gold/output/deck06-07-11-genmad.out` |
| 13 операций ЯМД из gold | `PLACE`..`BDPUT`, `EXN=0` | `gold/output/yam-predtgen.out` |
| подпрограмма `SHTAMP` из `raznoe.txt` | 44/58 координат совпали с расчётом | `gold/output/raznoe-shtamp-*.out` |

## 2. Подготовка рабочего стенда

Все команды выполняются в отдельном scratch-каталоге, который можно удалить. Оригинальные образы в `~/.besm6` и `/usr/local/share/besm6` не изменяются.

```sh
REPO=~/Yandex.Disk/re-compass
RUN=~/.cache/severov-repro
mkdir -p "$RUN"
cp ~/.besm6/{2048,2053,2099,2148,2348} "$RUN/"
cp ~/Yandex.Disk/dispak/tests/disks/2196 "$RUN/"
cd "$RUN"
md5sum * > MANIFEST.md5
```

## 3. Порядок запуска

Сборка `COMTUP` обязательна:почти все SERVIS-деки используют внешние `EXN`/`ITLEN`.

```sh
# 1) PERSO-библиотека COMTUP в зоне 2570 рабочей копии 2348
dispak --path=. -p "$REPO/tests/comtup_final_build.b6" > build-comtup.run 2> build-comtup.err

# 2) модуль SERVIS (дека встраивает src/servis.pas)
dispak --path=. -p "$REPO/tests/servis_build4.b6" > build-servis.run 2> build-servis.err

# 3) подлинные 41 строка через front-end
cp "$REPO/tests/original_deck_front.b6" .
dispak --path=. -p original_deck_front.b6 > original.run 2> original.err

# 4) SERVIS-операторы: адаптированная дека и дополнительные операции
cp "$REPO/tests/gold_servis.b6" "$REPO/tests/gold_servis_other.b6" .
dispak --path=. -p gold_servis.b6 > servis.run 2> servis.err
dispak --path=. -p gold_servis_other.b6 > servis-other.run 2> servis-other.err

# 5) транслятор схем (дека 2)
cp "$REPO/tests/ttc15.b6" .
dispak --path=. -p ttc15.b6 > ttc.run 2> ttc.err

# 6) генераторы загрузчиков и MAD (деки 6/7/11, 3/8/9)
cp "$REPO/tests/genmad.b6" .
dispak --path=. -p genmad.b6 > genmad.run 2> genmad.err

# 7) предтранслятор ЯМД
cp "$REPO/tests/predtgen.b6" .
dispak --path=. -p predtgen.b6 > predt.run 2> predt.err

# 8) FORTRAN-пример из raznoe.txt
cp "$REPO/tests/gold_shtamp.b6" "$REPO/tests/gold_shtamp_v.b6" .
dispak --path=. -p gold_shtamp.b6 > shtamp0.run 2> shtamp0.err
dispak --path=. -p gold_shtamp_v.b6 > shtamp1.run 2> shtamp1.err
```

## 4. Проверка результата

```sh
diff -u "$REPO/gold/output/deck01-servis-original.out" original.run
diff -u "$REPO/gold/output/deck01-servis-adapted.out" servis.run
diff -u "$REPO/gold/output/deck01-servis-extra-ops.out" servis-other.run
diff -u "$REPO/gold/output/deck02-ttc-schema.out" ttc.run
diff -u "$REPO/gold/output/deck06-07-11-genmad.out" genmad.run
diff -u "$REPO/gold/output/yam-predtgen.out" predt.run
diff -u "$REPO/gold/output/raznoe-shtamp-ns0.out" shtamp0.run
diff -u "$REPO/gold/output/raznoe-shtamp-ns1.out" shtamp1.run
```

Признаки успеха в каждом логе: баннер `PASCAL COMPILER 15.1 (28.10.26)`, отсутствие строк `******`, `EXN=0`, `GEN EX=0`/`MAD EX=0` где применимо, `КОНЕЦ ЗАДАЧИ`, пустой `stderr`.

## 5. Важные оговорки воспроизведения

- `original_deck_front.b6` содержит подлинные 41 строку, но в колонку 1 каждой входной карты добавлен один пробел. Без него монитор перехватывает `ШИФР`/`*CMP`/`*SERVIS` как системные карты и выдаёт `NO *END FILE`. SERVIS-операторы не изменены.
-Системные карты `*CMP`/`*SERVIS` в front-end пропускаются; исторический паспорт `ЗMП` и локальный монитор НИС Гидропроект недоступны (свип 31 паспорта, `docs/PASSPORT-SWEEP.md`).
- Персистентность МАРС между отдельными вызовами `dispak` не гарантирована. Деки `genmad`, `kompas_suite` и SERVIS держат всю цепочку в одном процессе. Для сохранения между задачами нужны LU 41 и монтирование с `-wr` (см. генераторы `tools/severov/chunk_*`).
- `ДЛИHA 1750` в первой деке хранится в дескрипторе SERVIS, но физически выделяется ≤1000 зон из-за буфера ядра. Патч `tools/mars/apply_inplace_patch.py` превращает превышение в управляемую ошибку `06`, но не снимает это ограничение.

## 6. Что дальше

Приоритеты по открытым пунктам:

1. **Патч ядра в штатный стенд.** Применяется к рабочей копии 2348 через `tools/mars/apply_inplace_patch.py`; после патча прогнать все пороговые тесты и SERVIS-эталоны. Пока проверено в scratch, в репозитории лежит только инструмент и отчёт.
2. **Сохранение бд-ключа.** Сейчас op89 меняет ключ в текущем дескрипторе, но после повторного `FIND` он возвращается к старому значению. Нужно найти путь записи в каталог МАРС (op54 не дал эффекта).
3. **Dispatch PIC 66/67/76/77.** Перевод этих операций в микрокоманды МАРС не доказан; `PicCode` по-прежнему смотрит только младший байт.
4. **Верхние слои.** Патчи в `patches/` не применялись к настоящим `UCOMPAS`/`TSSPPR`; `TSSPPR:271` (`TYPEM`) остаётся без обёртки. Нужно собрать эти модули с `COMTUP` на 15.1.
5. **Реестр кусков.** Для логической области 1750 зон: генераторы `tools/severov/chunk_*` показали работоспособность на LU 41, но в SERVIS реестр не встроен.
6. **Исторический путь.** Паспорт `ЗMП`, монитор НИС Гидропроект и компилятор с ленты `1C` недоступны; закрывается только при появлении носителей.

## 7. Как обновлять эталоны

Если после изменений вывод деки изменился осознанно: перегенерировать лог в чистом scratch, сверить что `stderr` пуст и `EXN=0`, затем скопировать вывод в `tests/<deck>.expected.txt` и в соответствующий файл `gold/output/`, обновить md5 в `gold/output/README.md`.
