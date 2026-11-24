# По ветвья: маркер -> ключ/данные -> строка вывода -> EX

| прог | ветвь | условие | ключ/данные | строка вывода | EX в логе |
|---|---|---|---|---|---|
| ZATMON | 01/01 | IF 'KOФ   '=ДИP | KOФ    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/01 | EX0=1/EX4=0 |
| ZATMON | 01/02 | IF 'OTД   '=ДИP | OTД    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/02 | EX0=1/EX4=0 |
| ZATMON | 01/03 | IF 'TEM   '=ДИP | TEM    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/03 | EX0=1/EX4=0 |
| ZATMON | 01/04 | IF 'ФAK   '=ДИP | ФAK    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/04 | EX0=1/EX4=0 |
| ZATMON | 01/05 | IF 'OБЩ   '=ДИP | OБЩ    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/05 | EX0=1/EX4=0 |
| ZATMON | 01/06 | IF 'KOH   '=ДИP | KOH    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/06 | EX0=1/EX4=0 |
| ZATMON | 01/07 | IF 'BЫX   '=ДИP | BЫX    | ГИСТРАЦИИ ФАКТИЧОБЩ - ВХОД В БЛОК РЕГИСТРАЦИИ ОБЩИХW6С/01/07 | EX0=1/EX4=0 |
| ZATMON | 02/01 | IF 'ПOC   '=ДИP | ПOC    | ПОС - ВЫДАЧА ОТЧЕТА ПО ПОСЛЕДНЕМУ МЕСЯW6С/02/01 | EX0=1/EX4=0 |
| ZATMON | 02/02 | IF 'KOH   '=ДИP | KOH    | ПОС - ВЫДАЧА ОТЧЕТА ПО ПОСЛЕДНЕМУ МЕСЯW6С/02/02 | EX0=1/EX4=0 |
| ZATMON | 02/03 | IF 'BЫX   '=ДИP | BЫX    | ПОС - ВЫДАЧА ОТЧЕТА ПО ПОСЛЕДНЕМУ МЕСЯW6С/02/03 | EX0=1/EX4=0 |
| ZATMON | 03/01 | IF 'KOH   '=ДИP | KOH    | ФЛА - ИНВЕРТИРОВАНИЕ ФЛАГОВ/W6С/03/01 | EX0=1/EX4=0 |
| ZATMON | 03/02 | IF 'BЫX   '=ДИP | BЫX    | ФЛА - ИНВЕРТИРОВАНИЕ ФЛАГОВ/W6С/03/02 | EX0=1/EX4=0 |
| ZATMON | 03/03 | IF 'ФЛA   '=ДИP | ФЛA    | ФЛА - ИНВЕРТИРОВАНИЕ ФЛАГОВ/W6С/03/03 | EX0=1/EX4=0 |
| ZATMON | 04/01 | IF 'PEГ   '=ДИP | PEГ    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/01 | EX0=1/EX4=0 |
| ZATMON | 04/02 | IF 'OTЧ   '=ДИP | OTЧ    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/02 | EX0=1/EX4=0 |
| ZATMON | 04/03 | IF 'CИC   '=ДИP | CИC    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/03 | EX0=1/EX4=0 |
| ZATMON | 04/04 | IF 'ЗAK   '=ДИP | ЗAK    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/04 | EX0=1/EX4=0 |
| ZATMON | 04/05 | IF 'CБP   '=ДИP | CБP    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/05 | EX0=1/EX4=0 |
| ZATMON | 04/06 | IF 'ПAP   '=ДИP | ПAP    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/06 | EX0=1/EX4=0 |
| ZATMON | 04/07 | IF 'KOH   '=ДИP | KOH    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/07 | EX0=1/EX4=0 |
| ZATMON | 04/08 | IF 'BЫX   '=ДИP | BЫX    | ЕНИЯ/СБР - СБРОСИТЬ ИЗМЕНЕНИЯ/СИС - ВХОД В СИСТЕМНЫЙ БЛОК/W6С/04/08 | EX0=1/EX4=0 |
| ZATZAT | 01/01 | IF BOSX.NAM='ZMEC  ' | ZMEC   | W6С/01/01 | EX0=2/EX4=73 |
| ZATZAT | 01/02 | IF BOSX.NAM='ZTEMA ' | ZTEMA  | W6С/01/02 | EX0=2/EX4=73 |
| ZATZAT | 01/03 | IF BOSX.NAM='ZOTД  ' | ZOTД   | W6С/01/03 | EX0=2/EX4=73 |
| ZATZAT | 01/04 | IF BOSX.NAM='ZЭTAП ' | ZЭTAП  | W6С/01/04 | EX0=2/EX4=73 |
| ZATZAT | 01/05 | IF BOSX.NAM='ZBЫП  ' | ZBЫП   | W6С/01/05 | EX0=2/EX4=73 |
| ZATZAT | 01/06 | IF BOSX.NAM='ZOЗAPП' | ZOЗAPП | W6С/01/06 | EX0=2/EX4=73 |
| ZATZAT | 01/07 | IF BOSX.NAM='ZДЗAPП' | ZДЗAPП | W6С/01/07 | EX0=2/EX4=73 |
| ZATZAT | 01/08 | IF BOSX.NAM='ZMATEP' | ZMATEP | W6С/01/08 | EX0=2/EX4=73 |
| ZATZAT | 01/09 | IF BOSX.NAM='ZKOMAH' | ZKOMAH | W6С/01/09 | EX0=2/EX4=73 |
| ZATZAT | 01/10 | IF BOSX.NAM='ZCПEЦ ' | ZCПEЦ  | W6С/01/10 | EX0=2/EX4=73 |
| ZATZAT | 01/11 | IF BOSX.NAM='ZAMOP ' | ZAMOP  | W6С/01/11 | EX0=2/EX4=73 |
| ZATZAT | 01/12 | IF BOSX.NAM='ZCTOP ' | ZCTOP  | W6С/01/12 | EX0=2/EX4=73 |
| ZATZAT | 01/13 | IF BOSX.NAM='ZПOCH ' | ZПOCH  | W6С/01/13 | EX0=2/EX4=73 |
| ZATZAT | 01/14 | IF BOSX.NAM='ZПTPEC' | ZПTPEC | W6С/01/14 | EX0=2/EX4=73 |
| ZATZAT | 01/15 | IF BOSX.NAM='ZПPБK ' | ZПPБK  | W6С/01/15 | EX0=2/EX4=73 |
| ZATZAT | 01/16 | IF BOSX.NAM='ZOBЫШ ' | ZOBЫШ  | W6С/01/16 | EX0=2/EX4=73 |
| ZATZAT | 01/17 | IF BOSX.NAM='ZOГOC ' | ZOГOC  | W6С/01/17 | EX0=2/EX4=73 |
| ZATZAT | 01/18 | IF BOSX.NAM='ZHEПЛ ' | ZHEПЛ  | W6С/01/18 | EX0=2/EX4=73 |
| ZATZAT | 02/01 | IF BOSX.NAM='ZBЫП  ' | ZBЫП   | W6С/02/01 | EX0=2/EX4=73 |
| ZATZAT | 02/02 | IF BOSX.NAM='ZOЗAPП' | ZOЗAPП | W6С/02/02 | EX0=2/EX4=73 |
| ZATZAT | 02/03 | IF BOSX.NAM='ZДЗAPП' | ZДЗAPП | W6С/02/03 | EX0=2/EX4=73 |
| ZATZAT | 02/04 | IF BOSX.NAM='ZMATEP' | ZMATEP | W6С/02/04 | EX0=2/EX4=73 |
| ZATZAT | 02/05 | IF BOSX.NAM='ZKOMAH' | ZKOMAH | W6С/02/05 | EX0=2/EX4=73 |
| ZATZAT | 02/06 | IF BOSX.NAM='ZCПEЦ ' | ZCПEЦ  | W6С/02/06 | EX0=2/EX4=73 |
| ZATZAT | 02/07 | IF BOSX.NAM='ZAMOP ' | ZAMOP  | W6С/02/07 | EX0=2/EX4=73 |
| ZATZAT | 02/08 | IF BOSX.NAM='ZCTOP ' | ZCTOP  | W6С/02/08 | EX0=2/EX4=73 |
| ZATZAT | 02/09 | IF BOSX.NAM='ZПOCH ' | ZПOCH  | W6С/02/09 | EX0=2/EX4=73 |
| ZATZAT | 02/10 | IF BOSX.NAM='ZПTPEC' | ZПTPEC | W6С/02/10 | EX0=2/EX4=73 |
| ZATZAT | 02/11 | IF BOSX.NAM='ZПPБK ' | ZПPБK  | W6С/02/11 | EX0=2/EX4=73 |
| ZATZAT | 02/12 | IF BOSX.NAM='ZOBЫШ ' | ZOBЫШ  | W6С/02/12 | EX0=2/EX4=73 |
| ZATZAT | 02/13 | IF BOSX.NAM='ZOГOC ' | ZOГOC  | W6С/02/13 | EX0=2/EX4=73 |
| ZATZAT | 02/14 | IF BOSX.NAM='ZHEПЛ ' | ZHEПЛ  | W6С/02/14 | EX0=2/EX4=73 |
| ZATZAT | 03/01 | IF NAM='ZMEC  ' | ZMEC   | W6С/03/01 | EX0=2/EX4=73 |
| ZATZAT | 03/02 | IF NAM='ZTEMA ' | ZTEMA  | W6С/03/02 | EX0=2/EX4=73 |
| ZATZAT | 03/03 | IF NAM='ZOTД  ' | ZOTД   | W6С/03/03 | EX0=2/EX4=73 |
| ZATZAT | 03/04 | IF NAM='ZЭTAП ' | ZЭTAП  | W6С/03/04 | EX0=2/EX4=73 |
| ZATZAT | 04/01 | IF (NAM='ZMEC  ') AND (MEC<>0) | ZMEC   | W6С/04/01 | EX0=2/EX4=73 |
| ZATZAT | 04/02 | IF (NAM='ZTEMA ') AND (TEM<>0) | ZTEMA  | W6С/04/02 | EX0=2/EX4=73 |
| ZATZAT | 04/03 | IF (NAM='ZOTД  ') AND (OTД<>-1) | ZOTД   | W6С/04/03 | EX0=2/EX4=73 |
| ZATZAT | 04/04 | IF TRUE | TRUE | W6С/04/04 | EX0=2/EX4=73 |
| ZATZAT | 05/01 | IF NAM='ZMEC  ' | ZMEC   | W6С/05/01 | EX0=2/EX4=73 |
| ZATZAT | 05/02 | IF NAM='ZTEMA ' | ZTEMA  | W6С/05/02 | EX0=2/EX4=73 |
| ZATZAT | 05/03 | IF NAM='ZOTД  ' | ZOTД   | W6С/05/03 | EX0=2/EX4=73 |
| ZATZAT | 05/04 | IF NAM='ZЭTAП ' | ZЭTAП  | W6С/05/04 | EX0=2/EX4=73 |
| ZATZAT | 06/01 | IF 'ПPO   '=ДИP | ПPO    | ТЫ/W6С/06/01 | EX0=2/EX4=73 |
| ZATZAT | 06/02 | IF 'HOB   '=ДИP | HOB    | ТЫ/W6С/06/02 | EX0=2/EX4=65 |
| ZATZAT | 06/03 | IF 'ИCK   '=ДИP | ИCK    | ТЫ/W6С/06/03 | EX0=2/EX4=72 |
| ZATZAT | 06/04 | IF 'KOH   '=ДИP | KOH    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/06/04 | EX0=2/EX4=73 |
| ZATZAT | 06/05 | IF 'BЫX   '=ДИP | BЫX    | ТЫ/W6С/06/05 | EX0=2/EX4=63 |
| ZATNAK | 01/01 | IF BOSX.NAM='NMEC  ' | NMEC   | W6С/01/01 | EX0=6/EX4=11 |
| ZATNAK | 01/02 | IF BOSX.NAM='NПPOЧ ' | NПPOЧ  | W6С/01/02 | EX0=6/EX4=11 |
| ZATNAK | 01/03 | IF BOSX.NAM='NHAKЛ ' | NHAKЛ  | W6С/01/03 | EX0=6/EX4=11 |
| ZATNAK | 01/04 | IF BOSX.NAM='NЗAHAK' | NЗAHAK | W6С/01/04 | EX0=6/EX4=11 |
| ZATNAK | 01/05 | IF BOSX.NAM='NЗAPП ' | NЗAPП  | W6С/01/05 | EX0=6/EX4=11 |
| ZATNAK | 02/01 | IF NAM='NMEC  ' | NMEC   | W6С/02/01 | EX0=6/EX4=11 |
| ZATNAK | 03/01 | IF NAM='NMEC  ' | NMEC   | W6С/03/01 | EX0=6/EX4=11 |
| ZATNAK | 04/01 | IF 'ПPO   '=ДИP | ПPO    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/04/01 | EX0=6/EX4=13 |
| ZATNAK | 04/02 | IF 'HOB   '=ДИP | HOB    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/04/02 | EX0=6/EX4=12 |
| ZATNAK | 04/03 | IF 'ИCK   '=ДИP | ИCK    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/04/03 | EX0=6/EX4=13 |
| ZATNAK | 04/04 | IF 'KOH   '=ДИP | KOH    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/04/04 | EX0=6/EX4=11 |
| ZATNAK | 04/05 | IF 'BЫX   '=ДИP | BЫX    | ПРО - ПРОСМОТР ЗАРЕГИСТРИРОВАННЫХ КАРТ/НОВ - РЕГИСТРАЦИЯ НОВЫХ КАРТ/ИСК - ИСКЛЮЧЕНИЕ КАРТЫ/W6С/04/05 | EX0=6/EX4=11 |
| ZATRTE | 01/01 | IF BOSX.NAM='THOMK ' | THOMK  | W6С/01/01 | EX0=1/EX4=22 |
| ZATRTE | 01/02 | IF BOSX.NAM='TЭTAП ' | TЭTAП  | W6С/01/02 | EX0=1/EX4=22 |
| ZATRTE | 01/03 | IF BOSX.NAM='TИCП  ' | TИCП   | W6С/01/03 | EX0=1/EX4=22 |
| ZATRTE | 01/04 | IF BOSX.NAM='TCOИ  ' | TCOИ   | W6С/01/04 | EX0=1/EX4=22 |
| ZATRTE | 01/05 | IF BOSX.NAM='TПOД  ' | TПOД   | W6С/01/05 | EX0=1/EX4=22 |
| ZATRTE | 02/01 | IF BOSX.NAM='THOMK ' | THOMK  | W6С/02/01 | EX0=1/EX4=22 |
| ZATRTE | 03/01 | IF NAM='THOMK ' | THOMK  | W6С/03/01 | EX0=1/EX4=22 |
| ZATRTE | 04/01 | IF NAM='THOMK ' | THOMK  | W6С/04/01 | EX0=1/EX4=22 |
| ZATRTE | 04/02 | IF (NAM='TИCП  ')OR(NAM='TCOИ  ')OR(NA | TИCП  ;TCOИ  ;TПOД   | W6С/04/02 | EX0=1/EX4=22 |
| ZATRTE | 05/01 | IF 'ЭTA   '=ДИP | ЭTA    | Ы/W6С/05/01 | EX0=1/EX4=22 |
| ZATRTE | 05/02 | IF 'ПPO   '=ДИP | ПPO    | Ы/W6С/05/02 | EX0=1/EX4=22 |
| ZATRTE | 05/03 | IF 'HOB   '=ДИP | HOB    | Ы/W6С/05/03 | EX0=1/EX4=23 |
| ZATRTE | 05/04 | IF 'ИCK   '=ДИP | ИCK    | Ы/W6С/05/04 | EX0=1/EX4=23 |
| ZATRTE | 05/05 | IF 'KOH   '=ДИP | KOH    | Ы/W6С/05/05 | EX0=1/EX4=22 |
| ZATRTE | 05/06 | IF 'BЫX   '=ДИP | BЫX    | Ы/W6С/05/06 | EX0=1/EX4=22 |
