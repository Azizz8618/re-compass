#!/usr/bin/env python3
"""W6b: restore KOMPAS SELECT branching as IF/ELSE chains.

Works on the stage1 sources (before W5d transforms).  Each SELECT arm
``cond: action;`` becomes ``IF cond THEN BEGIN action END ELSE ...`` so the
menu/witness dispatch and every DMLCALL snippet keep their original branch
and order.  Only the SELECT construct is rewritten; all other transformations
stay in the W5d/W5e pipeline.
"""
import re


def _spans(text):
    """Spans of comments and string literals that must not be split."""
    out = []
    i, n = 0, len(text)
    while i < n:
        if text.startswith('(*', i):
            j = text.find('*)', i + 2)
            j = n if j < 0 else j + 2
            out.append((i, j))
            i = j
        elif text[i] == "'":
            j = i + 1
            while j < n:
                if text[j] == "'":
                    if j + 1 < n and text[j + 1] == "'":
                        j += 2
                        continue
                    break
                j += 1
            out.append((i, min(n, j + 1)))
            i = j + 1
        else:
            i += 1
    return out


def _masked(index, spans):
    return any(a <= index < b for a, b in spans)


def _paren_delta(text):
    spans = _spans(text)
    d = 0
    for i, ch in enumerate(text):
        if _masked(i, spans):
            continue
        if ch == '(':
            d += 1
        elif ch == ')':
            d -= 1
    return d


def _split_top_level(text, sep=';'):
    spans = _spans(text)
    parts, last, depth = [], 0, 0
    for i, ch in enumerate(text):
        if _masked(i, spans):
            continue
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth = max(0, depth - 1)
        elif ch == sep and depth == 0:
            parts.append(text[last:i])
            last = i + 1
    parts.append(text[last:])
    return [p for p in parts if p.strip()]


def _strip_select_close(arm):
    """Drop KOMPAS group closes and unmatched ')' belonging to SELECT."""
    arm = arm.strip()
    while arm.endswith('_)'):
        arm = arm[:-2].rstrip()
    spans = _spans(arm)
    opens = sum(1 for i, c in enumerate(arm) if c == '(' and not _masked(i, spans))
    closes = [i for i, c in enumerate(arm) if c == ')' and not _masked(i, spans)]
    extra = len(closes) - opens
    if extra > 0:
        arm = arm[:closes[-extra]].rstrip()
    return arm


def _split_arm(arm):
    """Return (condition, action) split at the top-level ':' separator."""
    spans = _spans(arm)
    depth = 0
    for i, ch in enumerate(arm):
        if _masked(i, spans):
            continue
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth = max(0, depth - 1)
        elif ch == ':' and depth == 0:
            if i + 1 < len(arm) and arm[i + 1] == '=':
                continue
            return arm[:i].strip(), arm[i + 1:].strip()
    return arm.strip(), None


def _render_action(action):
    """Normalise an action into a 15.1-friendly statement."""
    action = action.strip()
    while action.endswith('_)'):
        action = action[:-2].rstrip()
    while action.startswith('(') and action.endswith(')'):
        if _paren_delta(action) != 0:
            break
        action = action[1:-1].strip()
    return action.rstrip(';').strip()


def translate(src, name):
    lines = src.splitlines()
    out, i, count = [], 0, 0
    while i < len(lines):
        line = lines[i]
        msel = re.search(r'\bSELECT\b', line)
        if not msel:
            out.append(line)
            i += 1
            continue
        prefix = line[:msel.start()]
        # Cumulative paren balance from the SELECT line; a negative balance
        # at a line end marks the line that closes this SELECT.
        bal = _paren_delta(line[msel.end():])
        block, j = [], i + 1
        while j < len(lines):
            block.append(lines[j])
            bal += _paren_delta(lines[j])
            if bal < 0:
                j += 1
                break
            j += 1
        arms = _split_top_level(' '.join(block))
        rendered = []
        for arm in arms:
            cond, action = _split_arm(_strip_select_close(arm))
            action = _render_action(action) if action is not None else ''
            if not cond:
                continue
            if not action:
                rendered.append('IF %s THEN BEGIN END' % cond)
            else:
                rendered.append('IF %s THEN BEGIN %s END' % (cond, action))
        repl = prefix + ' ELSE '.join(rendered) + ';'
        # BЗЯTЬ: the SELECT closed both its own group and the enclosing
        # `WHILE NOT NEXTPAR DO(` group.  Keep one `)` so group_parens can
        # turn that DO( into BEGIN ... END.
        if name == 'ZATZAT' and "Д!:=HEПЛ" in ' '.join(block):
            repl += ')'
        out.append(repl)
        count += 1
        i = j
    return '\n'.join(out) + '\n', count
