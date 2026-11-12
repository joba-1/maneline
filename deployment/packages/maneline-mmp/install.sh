#!/bin/sh
# Install the Mustang Micro Plus tools of maneline into DESTDIR, the way the
# distribution packages (maneline-mmp) do. Run from the top of the source tree:
#
#   deployment/packages/maneline-mmp/install.sh DESTDIR [DOCDIR]
#
# Layout: /usr/share/maneline-mmp/scripts (the mmp_*.py programs),
# /usr/share/maneline-mmp/web_ui (the browser page mmp_web.py serves),
# /usr/bin/mmp-<name> for each program, the documents in DOCDIR
# (default /usr/share/doc/maneline-mmp).
set -eu
dest=${1:?usage: install.sh DESTDIR [DOCDIR]}
docdir=${2:-/usr/share/doc/maneline-mmp}
share=$dest/usr/share/maneline-mmp

install -d "$share/scripts" "$share/web_ui/_static" "$dest/usr/bin" "$dest$docdir"
for f in scripts/mmp_*.py; do
    name=$(basename "$f" .py)
    # modules are imported; programs (those with a main part) get a command
    if ! grep -q '^if __name__ == .__main__.' "$f"; then
        install -m 644 "$f" "$share/scripts/"
        continue
    fi
    install -m 755 "$f" "$share/scripts/"
    cmd=$dest/usr/bin/$(echo "$name" | tr _ -)
    printf '#!/bin/sh\nexec python3 /usr/share/maneline-mmp/scripts/%s.py "$@"\n' "$name" > "$cmd"
    chmod 755 "$cmd"
done
install -m 644 web-app/web_ui/micro-plus.html "$share/web_ui/"
install -m 644 web-app/web_ui/_static/micro-plus.js web-app/web_ui/_static/style-font.css \
    web-app/web_ui/_static/maneline-icon-512x512.png "$share/web_ui/_static/"
cp -r web-app/web_ui/_static/css "$share/web_ui/_static/"
find "$share/web_ui" -type d -exec chmod 755 {} + -o -type f -exec chmod 644 {} +
install -m 644 docs/MUSTANG_MICRO_PLUS_*.md "$dest$docdir/"
