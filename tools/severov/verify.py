#!/usr/bin/env python3
import re,sys
from pathlib import Path
B=Path('/home/azizz/.local/share/vifm/Trash/tss-w5e-fix')
for tag in sys.argv[1:]:
    for name in ['SKLCAR','SKLOTC','AMOCAR','AMOOTC','AMOGRU','ZATMON','ZATCOF','ZATZAT','ZATNAK','ZATRTE','ZATTAB','AMOMON','SKLMON','SKLOTD','ZATOTD','AMOOTD','AMOHED','ZATHED']:
        p=B/'logs'/(tag+'-'+name+'.run') if tag!='final' else B/'logs'/('final-'+name+'.run')
        if not p.exists(): continue
        t=p.read_text(encoding='utf-8',errors='replace')
        d=len(re.findall(r'^\s*\*{4,}\d+\s',t,re.M))
        mad=bool(re.search(r'FULL.{0,30}ЕХ\s*=\s*0',t))
        end='КОНЕЦ ЗАДАЧИ' in t
        bad=bool(re.search(r'ОТСУТСТВУЕТ|ЗАПРЕЩ.КОМАНДА',t))
        err=(B/'logs'/(tag+'-'+name+'.err'))
        es=err.stat().st_size if err.exists() else -1
        print('%-6s %-8s diag=%-3d mad=%-5s end=%-5s bad=%-5s err=%d'%(tag,name,d,mad,end,bad,es))
