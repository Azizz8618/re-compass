#!/usr/bin/env python3
"""Classify unresolved KOMPAS identifiers by the way they are used."""
import re, sys
from pathlib import Path
from collections import defaultdict
BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5e-fix')
names = sys.argv[1:]
for name in names:
    src = (BASE/'work'/'stage1'/'src'/(name+'.pas')).read_text(encoding='utf-8')
    src = re.sub(r'\(\*.*?\*\)', '', src, flags=re.S)
    used = defaultdict(lambda: defaultdict(int))
    examples = defaultdict(list)
    for m in re.finditer(r'[A-Za-zА-Яа-яЁё][A-Za-zА-Яа-яЁё0-9_]*', src):
        w = m.group(0)
        tail = src[m.end():m.end()+60]
        head = src[max(0,m.start()-30):m.start()]
        if re.match(r'\s*\.', tail):
            used[w]['field']+=1
        elif re.match(r'\s*\(', tail):
            used[w]['call']+=1
        elif re.search(r'\b(WIТН|WITH)\s*$', head, re.I):
            used[w]['with']+=1
        elif re.search(r'[:=]\s*$', head) and re.match(r'\s*(record|RECORD|array|set|packed|integer|real|alfa|char|boolean|BOOL|INT)\b', tail, re.I):
            used[w]['decl_lhs']+=1
        elif re.match(r'\s*[:=]', tail) and re.search(r'\b(VAR|var)\b', head):
            used[w]['decl']+=1
        if len(examples[w])<2:
            examples[w].append((head[-24:]+w+tail[:34]).replace('\n',' '))
    print('=====',name)
    for w in sorted(used, key=lambda w: (-used[w]['field']-used[w]['with'], w)):
        u=used[w]
        if u['field'] or u['with'] or u['call']:
            print('%-16s %s | %s' % (w, ' '.join('%s:%d'%(k,v) for k,v in sorted(u.items())), examples[w][0][:78]))
