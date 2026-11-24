# W1: линковка tsspr с COMTUP/UCOMPAS. Отчёт

Дата: 24.11.2026. Scratch: `/home/azizz/.local/share/vifm/Trash/tss-w1-linkage`.
Репозиторий `/home/azizz/Yandex.Disk/re-compass` НЕ изменялся: ни одной записи, коммита или push.
Секреты не открывались, `env`/`printenv`/`set` не запускались, устройств и GUI не было.

## 1. Результат (факт)

Критерий W1 выполнен: при `*execute` строки `ОТСУТСТВУЕТ` отсутствуют, в загрузочном листе есть `ТSSРРR` и `СОМТUР`, баннер 15.1 и `КОНЕЦ ЗАДАЧИ` присутствуют.

| Прогон | Дека | exit | stderr | Баннер | `ОТСУТСТВУЕТ` | Диагностики |
|---|---|---:|---:|---|---:|---|
| Сборка COMTUP | `tests/comtup_final_build.b6` | 0 | 0 байт | 15.1 (28.10.26) | - | 0, `ДЛИНА LIBRARY 032 ЗОН` |
| Сборка UCOMPAS | `tests/ucompas_build.b6` | 0 | 0 байт | 15.0 (15.02.82) | - | 0, `ДЛИНА LIBRARY 003 ЗОН` |
| tsspr, только COMTUP | `tests/tsspr-linked.b6` | 0 | 0 байт | 15.1 | 0 | 1 звездочка, внутри строкового литерала |
| tsspr, COMTUP + UCOMPAS | `tests/tsspr-linked-ucompas.b6` | 0 | 0 байт | 15.1 | 0 | 1 звездочка, внутри строкового литерала |
| Функциональный тест UCOMPAS | `tests/ucompas_test.b6` | 0 | 0 байт | 15.1 | 0 | 0 |

Рабочая колода: `tests/tsspr-linked-ucompas.b6`. Её заголовок:

```text
шифр 419999 зс5^
лен 40(2348)^
лен 41(2196-wr)^
еев1а3
*name
*call yesmemory
*perso:402570
*perso:403350,cont
*stand
*call *pascal
(*=y+,s0,s7*)program tssppr(output);
```

Фрагмент загрузочного листа (РГФ-шрифт эмулятора, латиница отображается кириллическими глифами):

```text
928:           *ЕХЕСUТЕ
929-
930-        ТSSРРR     01000        Р/7А       26455        RGЕХРОRТ С 30403
931-        РRОGRАМ  Е 01000        Р/7АD    Е 26457        *РАSТЕL* С 30404
932-        Р/1D     С 05470        Р/3        26472        РАSЕVN     30435
933-        *ОUТРUТ* С 23745        Р/NW       26476        РАSNВ8     30456
934-        Р/SУS      24003        Р/GD     Е 26552        РRINТ8     30466
```

Программа дошла до выполнения и напечатала `ТSSРРR РОRТ: SТUВ ЕNТRУ`, затем `КОНЕЦ ЗАДАЧИ`.

## 2. Подготовка и контроль дисков (факт)

Созданы `disks/`, `backup/`, `src/`, `tests/`, `logs/`, `artifacts/`, `build/`, `docs/`.
В `disks/` скопированы 2048, 2053, 2099, 2148, 2348 из `~/.besm6` и 2196 из `~/Yandex.Disk/dispak/tests/disks`.
Резервы всех шести образов лежат в `backup/*.pristine.bak`.
Манифесты: `artifacts/DISKS.md5` (рабочие копии на момент старта) и `artifacts/ORIGINALS.md5` (оригиналы).
md5 эталонного 2348 совпадает с `docs/ZONE-ALLOCATION.md`: `b287267fe6163e7c5bf7fdd15a802ee0`.
dispak запускался только как `dispak --path=/home/azizz/.local/share/vifm/Trash/tss-w1-linkage/disks -p <колода>`.

После КАЖДОЙ записи в 2348 и в конце прогонялся
`python3 /home/azizz/Yandex.Disk/re-compass/tools/check_zone_changes.py /home/azizz/.local/share/vifm/Trash/tss-w1-linkage/disks/2348 /usr/local/share/besm6/2348`.
Логи: `logs/zone-check-after-comtup.txt`, `logs/zone-check-after-ucompas.txt`, `logs/zone-check-after-test.txt`, `logs/zone-check-final.txt`.
Везде `зонный контроль: PASS`, изменены только зоны 2574-2625 (PERSO COMTUP/SERVIS) и 3354-3356 (PERSO UCOMPAS).
Финальная проверка оригиналов `md5sum -c`: все шесть образов ЦЕЛЫ. В scratch изменился только 2348.

## 3. Сверка сигнатур (факт)

Реальные объявления взяты из `src/comtup.pas` (зона 2570) и `src/ucompas.pas` (зона 3350).
Все имена укладываются в 8 символов,самое длинное имя `TPCMPIN1` = 8.

| Имя в tsspr | Объявление в tsspr-linked | Реальное объявление в COMTUP | Итог |
|---|---|---|---|
| SSBF5 | `procedure SSBF5` | `procedure SSBF5` | совпало |
| TPCMP1I | `var p:integer; k:integer` | `var p:integer; k:integer` | совпало |
| TPCMP1A | `var p:alfa; k:integer` | `var p:alfa; k:integer` | совпало |
| TPCMP1B | `var p:boolean; k:integer` | `var p:boolean; k:integer` | совпало |
| TPCMP1P | `var p:AnyPtr; k:integer` | `var p:AnyPtr; k:integer`, AnyPtr = @integer | совпало |
| TPCMPP1 | `j:integer` | `j:integer` | совпало |
| TPCMPL1 | `j:integer` | `j:integer` | совпало |
| TPCMPIN1 | `j:integer` | `j:integer` | совпало |
| WPASRA | `procedure WPASRA` | `procedure WPASRA` | совпало |
| VPASR6 | `procedure VPASR6` | `procedure VPASR6` | совпало |
| EXN | `function EXN:integer` | `function EXN:integer` | совпало |
| ITLEN | `function ITLEN:integer` | `function ITLEN:integer` | совпало |
| APIC | `function APIC:@TYPPIC` | `function APIC:@PicT` | имя совпало, типы результата различны |
| APIC2 | `function APIC2:@TYPPIC2` | `function APIC2:@Pic2T` | имя совпало, типы результата различны |
| TPCMPAD1 | `procedure TPCMPAD1(var P:TYPEM); external` | в порту COMTUP отсутствует | заменено локальной заглушкой |

В оригинальном `COMTUP.PAS` из `TURK.ARJ~` есть `PROCEDURE TPCMPAD1(VAR P); EXTERNAL`.
Порт заменил её четырьмя типизированными обёртками TPCMP1I/A/B/P.
`patches/tsspr.patch` перевёл 30 из 31 вызова TPCMPAD1 в TSSPPR на типизированные обёртки со слотами 63-92.
В `src/tsspr.pas` остался один непереведённый вызов в `CompileMethod` (строка 269, `TPCMPAD1(tt)`) без номера слота.
В `src/tsspr-linked.pas` объявление `external` удалено, вызов сохранён, добавлена локальная процедура-заглушка с комментарием о том, что привязка слота относится к W4.
Ни один из 14 действительных внешних входов в копии tsspr не изменён.

## 4. Гипотезы и границы результата (не доказано)

- Различие типов `APIC/@TYPPIC` против `APIC/@PicT` (и `APIC2`) не мешает линковке по имени, но означает семантическое рассогласование структур. Это подтверждённый W4 риск, а не новая гипотеза.
- Локальная заглушка TPCMPAD1 сохраняет имя и точку вызова, но не восстанавливает запись адреса в PIC. Нужен номер слота и сверка с `TSSPPR.PRT`.
- Сборка UCOMPAS прошла баннером 15.0 (системный fallback), хотя `docs/UCOMPAS-PORT.md` утверждает 15.1. Функциональный тест UCOMPAS прошёл полностью, но это не доказывает корректность всех 296 вызовов TPCMPP1 в TSSPPR.
- `DML`, `INKOMP`, `INBPEM`, `zamtrb`, `SSENDM`, `ERM`, `howcom`, файловые процедуры по-прежнему заглушки, `SLANGM` не заполнен, три адреса заменены на nil. Отсутствие `ОТСУТСТВУЕТ` не означает работоспособную цепочку TSS.

## 5. Точка остановки

Stopping point не потребовался: задача W1 доведена до критерия. Остановка перед W2/W3/W4/W5, в репозиторий ничего не скопировано.

## 6. Сохранённые артефакты

- `src/tsspr-linked.pas` (1015 строк) и `tests/tsspr-linked.b6`, `tests/tsspr-linked-ucompas.b6` (рабочая колода).
- `tests/comtup_final_build.b6`, `tests/ucompas_build.b6`, `tests/ucompas_test.b6`: декы сборки и теста, скопированные из репозитория без изменений.
- `logs/build-comtup.run/.err`, `logs/build-ucompas.run/.err`, `logs/tsspr-linked.run/.err`, `logs/tsspr-linked-ucompas.run/.err`, `logs/test-ucompas.run/.err`.
- `logs/zone-check-*.txt`, `artifacts/*.exit`, `artifacts/DISKS.md5`, `artifacts/ORIGINALS.md5`.
- `backup/*.pristine.bak`: резервы всех шести образов.
