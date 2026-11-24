# W9b: каталог поиска исторических стоимостных area КОМПАС

Все команды выполнялись только на чтение. Оригиналы архивов, образов дисков и
репозиторий `/home/azizz/Yandex.Disk/re-compass` (HEAD `6a7dea1`) не изменялись.
Рабочие копии: `work/disks/`, резерв `backup/disks/`, манифесты
`backup/DISKS-BACKUP.md5` и `backup/DISKS-START.md5`.

## 1. Инвентаризация архивов

```sh
find /tmp/.private/azizz/opencode/ilyin-floppies \
     /home/azizz/.local/share/vifm/Trash \
     /home/azizz/Yandex.Disk/re-compass/gold \
  -type f \( -iname '*.zip' -o -iname '*.arj' -o -iname '*.arc' \
            -o -iname '*.lzh' -o -iname '*.tar*' -o -iname '*.gz' \
            -o -iname '*.7z' -o -iname '*.rar' -o -iname '*.bz2' \
            -o -iname '*.xz' -o -iname '*.Z' \) -printf '%p\t%s\n' | sort
```
Результат: `search/archives-inventory.txt`, 209 архивов: 116 ZIP, 80 ARJ,
8 ARC, 5 LZH (остальные пустые/вложенные `.zip~`, `.arj~`).

## 2. Список членов КАЖДОГО архива

```sh
python3 search/list_all_archives.py     # 7z l для всех 209 архивов
```
Лог: `search/all-archives-listing.txt` (полный вывод `7z l` по каждому архиву).
Дополнительно для 17 архивов с «AREAS» в имени:
```sh
unzip -l <архив>          # ZIP
unarj l <архив>           # ARJ
```
Лог: `search/areas-zips-listing.txt`, `search/areas-archives-paths.txt`.

Итог по именам членов:
- совпадений с префиксами `SY- PA- TE- IC- ET- OT-`: **0**;
- совпадений с `ZAT`, `STOIM`, `ЗАТРАТ`: **0**;
- все 17 AREAS-архивов содержат только сервисные area: `ADA.ARE`,
  `BPEMEH.ARE`, `OBPEM.ARE`, `SC.ARE`, `ZPROC.ARE`, `MAG.ARE`, `CBIB.ARE`,
  `DOCER.ARE`, `BIB.ARE`, `COERR.TXT`, плюс `BENAR.ARE`/`BENLIB.ARE` в
  `BENAREAS.ARJ`. Даты 1989-1995, PC-дистрибутив, не БЭСМ-зоны.
- 55 уникальных имён `.ARE` во всём архиве (полный список в логе); ни одного
  стоимостного.

## 3. Поиск по содержимому

```sh
python3 search/search_contents.py    # байтовый поиск, 3 кодировки
python3 search/search_contents2.py   # с границами слов, utf-8/cp866/koi8-r
python3 search/extract_all.py        # 7z x, рекурсивно, глубина <= 3
```
Извлечено 220 архивов / 4781 файл в `extracted/`. Просканировано 10453 файла
(включая 16402 на первом проходе до извлечения). Логи:
`search/content-matches.txt`, `search/content-matches2.txt`, `search/extract.log`.

123 различных area-подобных имени. Все стоимостные имена (`SY-HAK`, `SY-TEM`,
`SY-ПAP`, `ПA-ДEЙ`, `TE-ИCП`, `ИC-ЗAT`, `ЭT-ЗAT`, `OT-ИCП`) найдены **только**
в `gold/...1988-1989.txt` и в документах `docs/` (текст программ и сниппетов),
ни в одном `.ARE`/`.CXE`/`.SER` и ни в одном файле из `extracted/`.
В `extracted/` только 30 совпадений `СТОИМОСТЬ` в посторонних документах
(`BLANC.IBM`, `5DB.DOC`, `CONT5.TXT`, `GGUIDE.HLP`).

## 4. AREAS.CXE / AREAS.POD / AREASE.SER

```sh
unzip -p .../AREAS-inner.zip AREAS.CXE | iconv -f cp866 -t utf-8
unzip -p .../AREAS-inner.zip AREAS.POD | iconv -f cp866 -t utf-8
unzip -p .../AREAS-inner.zip AREASE.SER | iconv -f cp866 -t utf-8
```
`AREAS.CXE`: схемы только `MG` (магазин возвратов в МАД) и `BPEMEH`.
`AREAS.POD`: `COЗДATЬ ПOДCXE MAGG CXEMЫ MG`. `AREASE.SER`: сервисный отчёт
SYSLIB. Стоимостных схем нет.

## 5. gold: BESM-6 Severov 1988-89

```sh
grep -an 'HAБOP' "$GOLD"                       # схемы
grep -anE 'ФOPMAT|\[.*\*\]' "$GOLD"            # форматы и данные
grep -anE 'HAKЛ \[|ЗAT \[|CП-HAK|CП-ЗAT' "$GOLD"  # 0 совпадений
```
`GOLD=/home/azizz/Yandex.Disk/re-compass/gold/BESM-6 (Pavel Severov, NIS GIDROPROEKT) KOMPAS-based systems 1988-1989.txt`

Найдено:
- строки 772-857: полные `HAБOP` для `SY-OTД`, `SY-TEM`, `SY-HAK`, `OT-ИCП`,
  `TE-ИCП`, `ИC-ИCП`, `TE-ЭTA`, `ИC-ЗAT`, `ЭT-ЗAT`, `SY-ПAP`, `ПA-ПAP`,
  `ПA-TИП`, `TИ-ATP`, `ПA-ЦEЛ`, `ПA-ДEЙ`, `ПA-AЛФ`, `ПA-CTP`, `ПA-ЛOГ`;
- строки 993-1113: дека `ЗAГPYЗЧИK ЗATPAT` (`ZATNZG`) с подлинными данными:
  12 `ПA-ДEЙ` (коэффициенты), 23 отдела, 11 `TEMA`, 7 `COИCП`;
- **нет** `ФOPMAT HAKЛ`, `ФOPMAT ЗAT`, блоков `HAKЛ [`, `ЗAT [`,
  `CП-HAK [`, `CП-ЗAT [` - то есть ежемесячных накладомых и сумм затрат
  с числами в архиве нет.

## 6. Эксперимент с подлинными коэффициентами

```sh
python3 work/tools/patch_w9b_gold_cf.py \
  work/src/ZATTAB-w8-real.pas work/src/ZATTAB-w9b.pas
python3 work/tools/rebuild_deck_w9b.py \
  work/src/ZATTAB-w9b.pas work/decks/ZATTAB-w9b.b6 work/decks/ZATTAB-w8-real.b6
python3 work/tools/run_deck_w9b.py work/decks/ZATTAB-w9b.b6 w9b-ZATTAB-goldcf --reset
```
`CF[2..4]` заменены с 0.10/0.20/0.15 на подлинные 0.0/0.0/0.0, добавлен
`CF[9]:=-1.0` (gold `MИНУС`). Результат: `rc=0`, stderr=0, `******=0`,
224 строки `МАD FULL ЕХ=0`, заголовок `ТАБЛИЦА ЗАТРАТ ЗА МЕСЯЦ`, `ИТОГО`,
`КОНЕЦ ЗАДАЧИ`, зонный контроль `PASS`.
Дифф напечатанной таблицы с эталоном W8: **0 строк** (совпадает побайтово).
Причина: `BЫЧKOЭФ` (DMLCALL 328) перезаписывает `ZKПРОЧ/ZKHAКЛ/ZKЗAPH`
значениями из отсутствующих записей `SY-HAK`, поэтому подлинные константы
загрузчика не попадают в итоговую таблицу.
