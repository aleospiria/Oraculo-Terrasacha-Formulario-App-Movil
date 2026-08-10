#!/usr/bin/env python3
"""Inject sentence capitalization into TextField / TextFormField widgets."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib"

SKIP_MARKERS = (
    "TextInputType.emailAddress",
    "TextInputType.number",
    "TextInputType.numberWithOptions",
    "TextInputType.phone",
    "obscureText:",
)

INJECT = (
    "textCapitalization: terrasachaCapitalizacionTexto,\n"
    "      inputFormatters: terrasachaFormattersTexto(),\n"
)


def find_ctor_end(src: str, open_paren_idx: int) -> int:
    """open_paren_idx points at '(' of TextField(."""
    depth = 0
    j = open_paren_idx
    in_str: str | None = None
    while j < len(src):
        c = src[j]
        if in_str:
            if c == "\\" and j + 1 < len(src):
                j += 2
                continue
            if c == in_str:
                in_str = None
            j += 1
            continue
        if c in ("'", '"'):
            in_str = c
            j += 1
            continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return j + 1
        j += 1
    return len(src)


def ensure_theme_import(path: Path, src: str) -> str:
    if "theme.dart" in src:
        return src
    if path.parent.name == "screens" or path.parent.name == "widgets":
        return "import '../theme.dart';\n" + src
    return "import 'theme.dart';\n" + src


def patch_file(path: Path) -> bool:
    src = path.read_text(encoding="utf-8")
    if "TextField(" not in src and "TextFormField(" not in src:
        return False

    out: list[str] = []
    i = 0
    modified = False
    while i < len(src):
        m = re.match(r"(TextField|TextFormField)\(", src[i:])
        if not m:
            out.append(src[i])
            i += 1
            continue

        name_end = i + m.end() - 1  # index of '('
        end = find_ctor_end(src, name_end)
        block = src[i:end]

        if any(s in block for s in SKIP_MARKERS):
            out.append(block)
            i = end
            continue

        if "textCapitalization:" in block:
            if (
                "TerrasachaPrimeraMayusculaFormatter" not in block
                and "terrasachaFormattersTexto" not in block
                and "inputFormatters:" not in block
            ):
                block2 = re.sub(
                    r"(TextField|TextFormField)\(\s*",
                    lambda mm: mm.group(0)
                    + "inputFormatters: terrasachaFormattersTexto(),\n",
                    block,
                    count=1,
                )
                if block2 != block:
                    block = block2
                    modified = True
            out.append(block)
            i = end
            continue

        block2 = re.sub(
            r"(TextField|TextFormField)\(\s*",
            lambda mm: mm.group(0) + INJECT,
            block,
            count=1,
        )
        if block2 != block:
            modified = True
            block = block2
        out.append(block)
        i = end

    if not modified:
        return False

    new_src = "".join(out)
    if "terrasachaCapitalizacionTexto" in new_src or "terrasachaFormattersTexto" in new_src:
        new_src = ensure_theme_import(path, new_src)

    path.write_text(new_src, encoding="utf-8")
    return True


def main() -> None:
    changed: list[str] = []
    for path in ROOT.rglob("*.dart"):
        if path.name == "theme.dart":
            continue
        if patch_file(path):
            changed.append(str(path.relative_to(ROOT)))
    print(f"changed {len(changed)}")
    for c in changed:
        print(c)


if __name__ == "__main__":
    main()
