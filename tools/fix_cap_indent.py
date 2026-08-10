#!/usr/bin/env python3
"""Fix indentation after capitalization inject."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1] / "lib"

pat = re.compile(
    r"(textCapitalization: terrasachaCapitalizacionTexto,\n)"
    r"[ \t]*inputFormatters: terrasachaFormattersTexto\(\),\n"
    r"([ \t]*)([a-zA-Z_])"
)


def fix(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        # Infer indent from textCapitalization line
        # Find previous indent of textCapitalization
        return (
            m.group(1)
            + "      inputFormatters: terrasachaFormattersTexto(),\n"
            + m.group(2)
            + m.group(3)
        )

    # More robust: for each injection, align inputFormatters with textCapitalization
    lines = text.splitlines(keepends=True)
    out = []
    i = 0
    while i < len(lines):
        line = lines[i]
        out.append(line)
        if "textCapitalization: terrasachaCapitalizacionTexto" in line and i + 1 < len(lines):
            indent = re.match(r"^(\s*)", line).group(1)
            nxt = lines[i + 1]
            if "inputFormatters: terrasachaFormattersTexto()" in nxt:
                out.append(f"{indent}inputFormatters: terrasachaFormattersTexto(),\n")
                i += 2
                # next line may have lost indent before controller
                if i < len(lines):
                    rest = lines[i]
                    if rest.lstrip().startswith(
                        ("controller:", "maxLines:", "style:", "decoration:", "autofocus:", "onChanged:", "keyboardType:", "enabled:")
                    ) and not rest.startswith(indent):
                        out.append(indent + rest.lstrip())
                        i += 1
                continue
        i += 1
    return "".join(out)


def main() -> None:
    n = 0
    for path in ROOT.rglob("*.dart"):
        src = path.read_text(encoding="utf-8")
        if "terrasachaFormattersTexto" not in src:
            continue
        new = fix(src)
        if new != src:
            path.write_text(new, encoding="utf-8")
            n += 1
            print(path.relative_to(ROOT))
    print("fixed", n)


if __name__ == "__main__":
    main()
