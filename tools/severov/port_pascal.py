#!/usr/bin/env python3
"""Mechanical port of KOMPAS Pascal extensions to Pascal-Monitor 15.1 syntax.

Handled:
  * `THEN(` / `ELSE(` / `DO(` statement groups -> BEGIN ... END
  * `!` as inequality -> `<>`
  * `!` as an identifier suffix (BOS!, CUL!, Ц!) -> `_` suffix
Nothing here changes DMLCALL snippets; they are literal string assignments.
"""
import re

KEYWORDS_GROUP = ('THEN', 'ELSE', 'DO')


def _mask(text):
    """Return (chars, masked) where masked is True inside strings/comments."""
    chars = list(text)
    masked = [False] * len(chars)
    i = 0
    n = len(chars)
    while i < n:
        if text.startswith('(*', i):
            j = text.find('*)', i + 2)
            j = n if j < 0 else j + 2
            for k in range(i, j):
                masked[k] = True
            i = j
            continue
        if text[i] in ("'", '\u2019', '\u2018'):
            quote = text[i]
            j = i + 1
            while j < n:
                if text[j] == quote:
                    if j + 1 < n and text[j + 1] == quote:
                        j += 2
                        continue
                    break
                j += 1
            j = min(n, j + 1)
            for k in range(i, j):
                masked[k] = True
            i = j
            continue
        i += 1
    return chars, masked


def group_parens(text):
    """Replace `KEYWORD ( ... )` groups with `KEYWORD BEGIN ... END`."""
    chars, masked = _mask(text)
    n = len(chars)
    stack = []          # indices of all '(' ; value: True if a block paren
    i = 0
    while i < n:
        if not masked[i] and chars[i] == '(':
            # Is this '(' immediately after THEN/ELSE/DO (ignoring whitespace)?
            k = i - 1
            while k >= 0 and chars[k] in ' \t\n':
                k -= 1
            word_end = k + 1
            while k >= 0 and (chars[k].isalpha()):
                k -= 1
            word = ''.join(chars[k + 1:word_end]).upper()
            is_block = word in KEYWORDS_GROUP
            stack.append([i, is_block])
        elif not masked[i] and chars[i] == ')' and stack:
            op = stack.pop()
            if op[1]:
                chars[op[0]] = 'B'
                chars[i] = 'E'
                # Replace the character just before '(' with BEGIN by marking
                # the '(' itself and use a sentinel handled below.
        i += 1
    out = ''.join(chars)
    # The sentinel B/E letters must become full keywords; do it with a second
    # pass that tracks the same positions by re-scanning from the original.
    return out


def group_parens2(text):
    """Robust version: rewrite directly into BEGIN/END tokens."""
    chars, masked = _mask(text)
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
            while k >= 0 and chars[k].isalpha():
                k -= 1
            word = ''.join(chars[k + 1:end]).upper()
            stack.append((i, word in KEYWORDS_GROUP))
        elif not masked[i] and chars[i] == ')' and stack:
            op, is_block = stack.pop()
            if is_block:
                starts.add(op)
                ends.add(i)
        i += 1
    out = []
    for i, ch in enumerate(chars):
        if i in starts:
            out.append(' BEGIN')
        elif i in ends:
            out.append(' END')
        else:
            out.append(ch)
    return ''.join(out)


def bang_ops(text):
    """`A!B` -> `A<>B`; `NAME!` -> `NAME_`."""
    chars, masked = _mask(text)
    n = len(chars)
    out = []
    i = 0
    while i < n:
        if chars[i] == '!' and not masked[i]:
            prev = out[-1] if out else ''
            nxt = chars[i + 1] if i + 1 < n else ''
            if (prev.isalnum() or prev == '_') and not (nxt.isalnum() or nxt == '_'):
                out.append('_')
            else:
                out.append('<>')
        else:
            out.append(chars[i])
        i += 1
    return ''.join(out)


def port(text):
    text = group_parens2(text)
    text = bang_ops(text)
    return text


if __name__ == '__main__':
    import sys
    from pathlib import Path
    p = Path(sys.argv[1])
    print(port(p.read_text(encoding='utf-8')))
