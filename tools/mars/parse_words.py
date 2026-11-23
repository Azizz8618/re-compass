import re,sys
listing,gold=sys.argv[1],sys.argv[2]
RE_WORD=re.compile(r"^([0-7]{16})\b")
RE_CMD=re.compile(r"^(\d{2})\s+(\d{2,3})\s+(\d{4,5})\b")
RE_SHORT=re.compile(r"^(\d{2})\s+(\d{2,3})\s*$")
words={};pending=None
for line in open(listing,encoding='utf-8',errors='replace'):
    a=line[25:30]; rest=line[31:].lstrip()
    addr=int(a,8) if re.fullmatch(r'\d{5}',a) else (None if not a.strip() else 'bad')
    if addr=='bad': continue
    m=RE_WORD.match(rest)
    if m:
        if addr is not None:
            words[addr]=int(m.group(1),8);pending=None
        continue
    m=RE_CMD.match(rest)
    if not m:
        m2=RE_SHORT.match(rest)
        if m2:
            reg,op,af=int(m2.group(1),8),int(m2.group(2),8),0
            half=(reg<<20)|(op<<15)|af
            if addr is not None:
                pending=addr;words[addr]=half<<24
            elif pending is not None:
                words[pending]|=half;pending=None
        continue
    if m:
        reg,op,af=int(m.group(1),8),int(m.group(2),8),int(m.group(3),8)
        if reg==0 and op==0 and len(m.group(3))==5:
            # short constant printed as 00 00 NNNNN (5-digit operand)
            if addr is not None:
                words[addr]=af; pending=None
            continue
        half=(reg<<20)|(op<<(15 if len(m.group(3))==5 else 12))|af
        if addr is not None:
            pending=addr;words[addr]=half<<24
        elif pending is not None:
            words[pending]|=half;pending=None
d=open(gold,'rb').read()
gw=[int.from_bytes(d[i*6:i*6+6],'big') for i in range(len(d)//6)]
# Look for longest contiguous run match between compiled words at base B and dump
best=(0,0,-1)
for base in range(0o2000,0o2000+0o2000,1):
    run=0
    for i in range(min(len(gw),len(words))):
        if words.get(base+i)==gw[i]: run+=1
        else: break
    if run>best[2]: best=(base,0,run)
print('best contiguous run:',oct(best[0]),best[2])
base=best[0]
ok=bad=miss=0
diffs=[]
for i,g in enumerate(gw):
    c=words.get(base+i)
    if c is None: miss+=1
    elif c==g: ok+=1
    else:
        bad+=1
        if len(diffs)<20: diffs.append((i,oct(base+i),format(g,'016o'),format(c,'016o')))
print('words',len(gw),'ok',ok,'bad',bad,'missing',miss)
for x in diffs: print('DIFF word %04o addr %s gold %s new %s'%x)
