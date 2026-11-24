#!/usr/bin/env python3
"""W5d transformations turning KOMPAS-flavoured Pascal into Pascal-Monitor 15.1.

Stages (applied in this order):
  1. OUT/INP/OUTRUT -> output/input (KOMPAS file aliases)
  2. `!` -> `<>` for comparisons, `_` for identifier suffixes
  3. `THEN(` / `ELSE(` / `DO(` / `label:(` groups -> BEGIN ... END
  4. `SELECT 'key'=EXPR: stmt; ... END` -> IF/ELSIF chain
  5. shim declarations inserted into the correct type/var/procedure sections
"""
import re

KEY_GROUP = ('THEN', 'ELSE', 'DO', 'BEGIN')


def mask(text):
    chars = list(text)
    masked = [False] * len(chars)
    i, n = 0, len(chars)
    while i < n:
        if text.startswith('(*', i):
            j = text.find('*)', i + 2)
            j = n if j < 0 else j + 2
            for k in range(i, j):
                masked[k] = True
            i = j
            continue
        if text[i] == "'":
            q, j = text[i], i + 1
            while j < n:
                if text[j] == q:
                    if j + 1 < n and text[j + 1] == q:
                        j += 2
                        continue
                    break
                j += 1
            for k in range(i, min(n, j + 1)):
                masked[k] = True
            i = j + 1
            continue
        i += 1
    return chars, masked


def replace_aliases(src):
    src = re.sub(r'\bOUTRUT\b', 'output', src)
    src = re.sub(r'\bOUT\b', 'output', src)
    src = re.sub(r'\bINP\b', 'input', src)
    return src


def fix_bang(text):
    chars, masked = mask(text)
    out = []
    for i, ch in enumerate(chars):
        if ch == '!' and not masked[i]:
            nxt = chars[i + 1] if i + 1 < len(chars) else ' '
            # Suffix markers (BOS!, CUL!, Ц!) are followed by '.', ';', ')',
            # ',' or whitespace.  Everything else is an inequality operator.
            out.append('_' if nxt in '.;, )' else '<>')
        else:
            out.append(ch)
    return ''.join(out)


def group_parens(text, case_labels=False):
    chars, masked = mask(text)
    n = len(chars)
    stack = []
    starts, ends = set(), set()
    i = 0
    while i < n:
        if not masked[i] and chars[i] == '(':
            k = i - 1
            while k >= 0 and chars[k] in ' \t\n\r':
                k -= 1
            end = k + 1
            while k >= 0 and (chars[k].isalpha() or chars[k].isdigit()):
                k -= 1
            word = ''.join(chars[k + 1:end]).upper()
            is_block = word in KEY_GROUP
            if case_labels and not is_block and end > 0 and chars[end - 1] == ':':
                is_block = True
            stack.append((i, is_block))
        elif not masked[i] and chars[i] == ')' and stack:
            pos, is_block = stack.pop()
            if is_block:
                starts.add(pos)
                ends.add(i)
        i += 1
    out = []
    for i, ch in enumerate(chars):
        if i in starts:
            out.append(' BEGIN ')
        elif i in ends:
            out.append(' END ')
        else:
            out.append(ch)
    return ''.join(out)


def _find_matching_end(text, start, allow_fallback=False):
    """Index of the END token closing a SELECT/CASE that starts at `start`."""
    chars, masked = mask(text)
    pat = re.compile(r'\b(BEGIN|CASE|SELECT|REPEAT|END|UNTIL|THEN|DO|ELSE)\b')
    depth = 0
    last_end = None
    for m in pat.finditer(text, start):
        if masked[m.start()]:
            continue
        w = m.group(1).upper()
        if w in ('BEGIN', 'CASE', 'SELECT', 'REPEAT'):
            depth += 1
        elif w == 'END':
            depth -= 1
            if depth == 0:
                return m.start()
            last_end = m.start()
    return last_end if allow_fallback else None


def _split_arms(body):
    chars, masked = mask(body)
    pat = re.compile(r'\b(BEGIN|CASE|SELECT|REPEAT|END)\b')
    depth = 0
    paren = 0
    parts = []
    last = 0
    for m in pat.finditer(body):
        if masked[m.start()]:
            continue
        w = m.group(1).upper()
        if w in ('BEGIN', 'CASE', 'SELECT', 'REPEAT'):
            depth += 1
        elif w == 'END':
            depth -= 1
        continue
    # Split on semicolons at nesting level zero, counting parens too.
    for i, ch in enumerate(chars):
        if masked[i]:
            continue
        if ch == '(':
            paren += 1
        elif ch == ')':
            paren -= 1
        elif ch == ';':
            # Determine keyword depth up to i.
            d = 0
            for m in pat.finditer(body[:i]):
                if masked[m.start()]:
                    continue
                w = m.group(1).upper()
                if w in ('BEGIN', 'CASE', 'SELECT', 'REPEAT'):
                    d += 1
                elif w == 'END':
                    d -= 1
            if d <= 0 and paren <= 0:
                parts.append(body[last:i])
                last = i + 1
    parts.append(body[last:])
    return [p for p in parts if p.strip()]


def normalize_stmt(stmt):
    stmt = stmt.strip().rstrip(';').strip()
    while stmt.startswith('(') and stmt.endswith(')'):
        stmt = 'BEGIN ' + stmt[1:-1].strip() + ' END'
    stmt = group_parens(stmt, case_labels=True)
    # KOMPAS closing groups can leave unmatched ')' after the conversion.
    while stmt.endswith(')') and stmt.count('(') < stmt.count(')'):
        stmt = stmt[:-1].rstrip()
    stmt = re.sub(r'\)+\s*END\s*$', ' END', stmt)
    return stmt


def translate_select(text):
    chars, masked = mask(text)
    pat = re.compile(r'\bSELECT\b')
    pos = 0
    while True:
        m = pat.search(text, pos)
        if not m or masked[m.start()]:
            break
        end = _find_matching_end(text, m.start())
        if end is None:
            break
        body = text[m.end():end].replace('∧', ' AND ').replace('∨', ' OR ')
        arms = _split_arms(body)
        # Derive an implicit selector from the first comparison arm.
        selector = None
        parsed = []
        for arm in arms:
            am = re.match(r"\s*'([^']*)'\s*=\s*(.+?)\s*:\s*(.*)", arm, re.S)
            if am:
                lit, expr, stmt = am.groups()
                selector = expr.strip()
                parsed.append(('expr', selector, lit, stmt))
                continue
            am = re.match(r"\s*(.+?)\s*:\s*(.*)", arm, re.S)
            if am:
                left, stmt = am.groups()
                parsed.append(('left', left.strip(), None, stmt))
                continue
            parsed.append(('raw', arm.strip(), None, ''))
        rendered = []
        for kind, left, lit, stmt in parsed:
            if kind == 'expr':
                cond = "(%s='%s')" % (left, lit)
            elif kind == 'left':
                if re.match(r"'[^']*'$", left) and selector:
                    cond = "(%s=%s)" % (selector, left)
                elif re.search(r'(=|<>)', left):
                    cond = '(' + left + ')'
                else:
                    cond = '(' + left + ')'
            else:
                rendered.append(left)
                continue
            stmt = normalize_stmt(stmt)
            rendered.append("IF %s THEN BEGIN %s END" % (cond, stmt))
        repl = ' ELSE '.join(rendered)
        text = text[:m.start()] + repl + text[end + 3:]
        pos = m.start() + len(repl)
        chars, masked = mask(text)
    return text


def translate_case(text):
    """CASE <expr> OF 'lit': stmt; ... END -> IF chain (string labels)."""
    chars, masked = mask(text)
    pat = re.compile(r'\bCASE\b')
    pos = 0
    while True:
        m = pat.search(text, pos)
        if not m or masked[m.start()]:
            break
        head = re.match(r'\s*(.+?)\s+OF\b', text[m.end():], re.S)
        if not head:
            pos = m.end()
            continue
        body_start = m.end() + head.end()
        end = _find_matching_end(text, m.start(), allow_fallback=True)
        if end is None:
            break
        expr = head.group(1).strip()
        body = text[body_start:end]
        arms = []
        for arm in _split_arms(body):
            am = re.match(r"\s*'([^']*)'\s*:\s*(.*)", arm, re.S)
            if not am:
                arms.append(arm.strip())
                continue
            lit, stmt = am.groups()
            stmt = normalize_stmt(stmt)
            arms.append("IF (%s='%s') THEN BEGIN %s END" % (expr, lit, stmt))
        repl = ' ELSE '.join(arms)
        # KOMPAS merges the CASE END with the enclosing BEGIN/END.  When no
        # separate CASE END exists, keep an extra END for the outer block.
        tail = text[end + 3:]
        if not re.search(r'\bEND\b', tail):
            repl += ' END; END;'
        text = text[:m.start()] + repl + text[end + 3:]
        pos = m.start() + len(repl)
        chars, masked = mask(text)
    return text


def pad_compare_literals(src, alfa_names=()):
    """KOMPAS pads short string literals to the alfa width on comparisons.

    Pascal-Monitor 15.1 does not, so a 3-character label compared with an
    `alfa` variable has to be padded to six characters explicitly.
    """
    pat = re.compile(r"'([^']{1,5})'")
    out = []
    pos = 0
    for m in pat.finditer(src):
        if m.start() < pos:
            continue
        before = src[max(0, m.start() - 14):m.start()]
        after = src[m.end():m.end() + 14]
        ctx = before + after
        alfa_ctx = any(re.search(r'\b' + re.escape(n) + r'\b', ctx)
                       for n in alfa_names)
        if alfa_ctx and re.search(r'(?<![<>:])=(?!=)|<>|:=', ctx):
            lit = m.group(1) + ' ' * (6 - len(m.group(1)))
            out.append(src[pos:m.start()])
            out.append("'" + lit + "'")
            pos = m.end()
    out.append(src[pos:])
    return ''.join(out)


def insert_shim(src, shim):
    """shim = dict(types, vars, procs)."""
    m1 = '  ZZBUFT = record LEN,H,D,I:integer; M:TYPEM end;'
    m2 = '  C: char;'
    m3 = 'procedure DmlCall'
    assert m1 in src and m2 in src and m3 in src, 'shim anchors missing'
    src = src.replace(m1, m1 + '\n' + shim['types'], 1)
    src = src.replace(m2, m2 + '\n' + shim['vars'], 1)
    src = src.replace(m3, shim['procs'] + '\n' + m3, 1)
    return src


def transform(src, shim=None):
    src = replace_aliases(src)
    src = fix_bang(src)
    src = group_parens(src, case_labels=False)
    src = translate_select(src)
    src = translate_case(src)
    alfa_names = []
    if shim:
        alfa_names = re.findall(r'^\s*(\w+)\s*:\s*alfa\s*;',
                                shim['vars'], re.M)
    src = pad_compare_literals(src, alfa_names)
    if shim:
        src = insert_shim(src, shim)
    return src
