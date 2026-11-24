# Манифест источников

Пути указаны для текущей рабочей машины. Внутриархивные пути даны относительно корня распакованного архива `Ильин_дискеты_февраль_2022/`. Исходный ZIP не изменяется.

## Pascal-текст КОМПАС

| Путь внутри архива | Роль |
|---|---|
| `00_3M_10/10_09_TURK/FILES/TURK.ARJ~/TSSDML.PAS` | SSDML, язык манипулирования данными, 3142 строки |
| `TURK.ARJ~/COMFY.PAS`, `TTC.PAS`, `TSERVIS.PAS`, `GEN.PAS`, `TPREDT.PAS`, `TSSBAS.PAS`, `TSPIC.PAS`, `COMTUP.PAS` | классический Компас-РС, 1994 |
| `00_3M_10/10_01_KOMPAS/FILES/SYS.ARJ~/TYPES.PAS`, `CMPSNO.PAS`, `UCMPSN.PAS`, `UCOMPAS.PAS`, `UNPIC.PAS`, `GSC.PAS` | «новая версия 94 года», модель данных и API |
| `00_3M_10/10_16/FILES/950112MX.ARJ~/UCOMPIL.PAS`, `UACTIONS.PAS`, `STARTUP.PAS`, `EDITORS.PAS` | компилятор выражений и GUI-оболочка |
| `00_3M_10/10_12/FILES/ASM.ARJ~/MARS.ASM` | эмулятор МАРС на x86, референс семантики |
| `00_3M_10/10_06/FILES/SYST/SYST.ARJ~/MICROCOD.TXT` | описание микрокода, спецификация PIC |
| `00_3M_10/10_14/FILES/COMTUP.PAS`, `COMPASS.TPP`, `COMPASS.TPU` | новейшая версия интерфейса и скомпилированное ядро |

Полный список: `inventory/pascal-sources.tsv`.

## Документация КОМПАС

| Путь внутри архива | Роль |
|---|---|
| `00_3M_10/10_01_KOMPAS/FILES/DKHELP.ARJ~/COMHELP` | полное описание системы, библиография |
| `00_3M_10/10_10/FILES/COMDOC/CDOC.ARJ~/K11.TXT`..`K72.TXT` | 22 файла, 1994, около 400 КБ |
| `03_MAXELL_5_6/5_10/FILES/PREPR/PREPR90.ZIP~/K1T1.TXT` | препринт 1990, среда БЭСМ-версии |
| `03_MAXELL_5_6/5_10/FILES/PREPR/PREPR90.ZIP~/CONT.TXT` | оглавление полного описания, 14 глав |
| `01_YELLOW_BOX_7/7_01/FILES/FIL/FIL.ARJ~/AMER.TXT`, `JAP.TXT`, `OTCET.TXT`, `SEREBR.TXT`, `K72.TXT` | биографии, отчёты, библиография 1983 |
| `01_YELLOW_BOX_7/7_01/FILES/FIL/ARTICLE.DOC` | «Состояние и перспективы СУБД КОМПАС-PC», 1989 |
| `03_MAXELL_5_6/5_12/FILES/ARTICLE.DOC` | «Сравнительный анализ СУБД КОМПАС» |
| `03_MAXELL_5_6/5_12/FILES/POLSA.TXT` | Филиппов, совместимость BESM-6/ES/SM/8086 |
| `00_3M_10/10_06/FILES/SYST/TZSQL.TXT`, `SQL.T` | ТЗ 1995 и проект SQL-интерфейса |

## МАРС и БЭСМ-6

| Путь | Роль |
|---|---|
| `/home/azizz/besm6.github.io/sources/mars/README.md` | таблица процедур и микрокоманд 00-55 |
| `/home/azizz/besm6.github.io/sources/mars/errors.md` | коды диагностики МАРС |
| `/home/azizz/besm6.github.io/sources/mars/re-mars.asm`, `re-mars.txt` | дизассемблирование ядра БАНДИТ |
| `/home/azizz/besm6.github.io/sources/mars/re-bandit.asm`, `re-bd.asm` | утилиты БАНДИТ и BD |
| `/home/azizz/besm6.github.io/sources/mars/pasbdi.asm`, `pasacd.asm`, `passetar.asm` | мост Pascal к МАРС, DTRAN 01.06.84 |
| `/home/azizz/besm6.github.io/sources/mars/sorucom.b6`, `example.b6`, `experiment.b6` | рабочие декы 2023 года |
| `/home/azizz/besm6.github.io/wiki/pascal-monitor.txt` | §Г4, зоны 30 и 63, стандартные процедуры |
| `/usr/local/share/besm6/2348`, `~/.besm6/2348` | рабочий диск, БАНДИТ в зоне 0657 |
| `/usr/local/share/besm6/2048` | код МАРС в зоне 630₈ для исторических колод |

## Смежные проекты и инструменты

| Путь | Роль |
|---|---|
| `/home/azizz/Yandex.Disk/pascal-re/tools/perso-run.sh` | сценарий компиляции Pascal, `*STAND` |
| `/home/azizz/Yandex.Disk/pascal-re/PERSO.md`, `errors.txt` | правила PERSO, ошибки компилятора |
| `/home/azizz/Yandex.Disk/dispak/tests/arfalib/` | библиотека 02570, тесты Pascal |
| `/home/azizz/Yandex.Disk/dispak/tests/run-test.py` | эталонное сравнение выводов |
| `/home/azizz/Yandex.Disk/re-dispak/AGENTS.md`, `DISK2348.md` | команды ДИСПАК, адреса зон |
| `/home/azizz/Yandex.Disk/re-bemsh/AGENTS.md`, `docs/COPIES-2348.md` | правила сверки и три копии тома |
| `/home/azizz/Yandex.Disk/re-siprod/` | пример PERSO-записи на 2348 |

## Веб-источники

| URL | Роль |
|---|---|
| https://www.computer-museum.ru/articles/materialy-mezhdunarodnoy-konferentsii-sorucom-2023/6896/ | материалы SoRuCom-2023 |
| https://www.computer-museum.ru/document/Sorucom_2023/Sorucom-2023_Bruhis_108-112.pdf | статья Брухиса, с. 106-112 |
| https://rusneb.ru/catalog/000199_000009_001360752/ | «Семейство СУБД Компас», 1987 |

## Права

Авторские права на архивные тексты принадлежат их авторам (В. И. Филиппов, О. А. Полукеев, В. В. Пржиялковский, А. В. Бобров, М. Р. Папиашвили, С. Е. Тихомиров, А. Ф. Урахчин и другие). В репозиторий включены только краткие цитаты и пути к файлам. См. `NOTICE.md`.
