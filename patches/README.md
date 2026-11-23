# Минимальные патчи верхних слоёв

Патчи содержат только изменённые строки (unified diff с нулевым контекстом), полные тексты исходников не перераспределяются. Исходники - из архива Ильина, кодировка CP866 с CRLF, поэтому применять нужно с `--binary`.

| Патч | Целевой файл | Изменено строк | Обёртки |
|---|---|---:|---|
| `ucompat.patch` | `UCOMPAS.PAS` | 24 | `TPCMP1I` x22, `TPCMP1P` x2 |
| `unpic.patch` | `UNPIC.PAS` | 1 | `TPCMP1I` x1 |
| `tsspr.patch` | `TSSPPR.PAS` | 30 | `TPCMP1I` x22, `TPCMP1A` x4, `TPCMP1B` x3, `TPCMP1P` x1 |

## Применение

```sh
patch --binary -p1 -d /путь/к/pascal-sources < patches/ucompat.patch
patch --binary -p1 -d /путь/к/pascal-sources < patches/unpic.patch
patch --binary -p1 -d /путь/к/pascal-sources < patches/tsspr.patch
```

Проверка перед применением: `patch --dry-run --binary -p1 -d <каталог> < <патч>`. Все три dry-run прошли.

## Распределение слотов

- `UCOMPAS.PAS:103,104` (`CGetBdKey`): `[22]` для `Number`, `[24]` для `R`. Это обязательная пара: `TPCMPIN1` при `j = 7514` читает адрес результата из `BDVECT[24].p`.
- Остальные вызовы UCOMPAS: слоты `40..61`.
- `UNPIC.PAS:159`: слот `62`.
- `TSSPPR.PAS`: слоты `63..92`.

Слоты не пересекаются с занятыми `[3]`, `[8]`, `[11]`, `[13]`, `[20]`, `[29]`, `[31]`, `[36]`, `[39]`, `[160]`, `[161]`. Внутри каждого блока слоты различны: `CReplaceElement` - `40/41`, `CPutBdKey` - `42/43`, `CGetKnotByKey` - `45/46` и `47`, `CFindByKeyElement` - `55/56`.

## Неразрешённые случаи

1. `TSSPPR.PAS:271`: `tt: TYPEM = PACKED ARRAY[1..1344] OF CHAR`. Нет совместимой обёртки, строка намеренно оставлена как `TPCMPAD1(tt)`. Для неё потребовался бы 19-й вход в `COMTUP`, то есть предел без запаса; сейчас добавление не планируется.
2. `UCOMPAS.PAS:281`: нетипизированный `var Key`; по `UCMPSN.PAS:612` выбран `TPCMP1P`, но тип зависит от `EType`.
3. `UNPIC.PAS:159`: `jj: word` против `var p:integer` - риск ошибки 40.
4. `longint`/`CmpsAddr` против `var integer`: совместимость на эмуляторе не проверялась.
5. `PSchemeSpace` и `Pointer` против `AnyPtr = @integer`: риск ошибки 40.

Для первого прогона `CGetBdKey` достаточно `ucompat.patch` и `unpic.patch`: `UCOMPAS.PAS:46` подключает `unPic`, поэтому `UNPIC` должен компилироваться.
