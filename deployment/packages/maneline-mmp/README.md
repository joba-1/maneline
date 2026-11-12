# maneline-mmp: the Mustang Micro Plus tools as a distribution package

The package `maneline-mmp` contains only maneline's Mustang Micro Plus programs
(`scripts/mmp_*.py`), the browser page `mmp_web.py` serves and the Micro Plus
documents. It needs Python 3.11+, `dbus-fast` and BlueZ 5.84+, all taken from the
distribution: no venv, no `bleak` on Linux.

| File | For |
|---|---|
| `install.sh` | puts the files into a destination directory; all three package formats call it |
| `maneline-mmp.spec` | RPM (openSUSE Tumbleweed, Leap 16.0) |
| `PKGBUILD` | Arch |
| `debian/` | Debian 13, Raspberry Pi OS |

Installed layout: `/usr/share/maneline-mmp/scripts`, `/usr/share/maneline-mmp/web_ui`,
commands `mmp-web`, `mmp-ble`, `mmp-backup`, `mmp-restore`, `mmp-audition`, `mmp-check`,
`mmp-level` in `/usr/bin`, the documents in the package's doc directory. Backups go to
`~/.local/share/maneline-mmp/backups` unless `--out` or `MMP_WORK_DIR` says otherwise.

## How it is built

On the openSUSE Build Service, project `home:joba1:chordsplay`, package `maneline-mmp`:
a `_service` file fetches a branch of the git repository as `maneline-mmp-<version>.tar.xz`
(`tar_scm` with `filename` = `maneline-mmp` and `versionformat` = `0.3.6+git%cd.%h`,
then `recompress` and `set_version`); the spec, the PKGBUILD and the Debian files
(as `debian.control`, `debian.rules`, … plus a `.dsc`) are copies of the files here.
Every build runs the unit tests (`python3 -m unittest discover -s scripts/tests`).

By hand, from the top of the source tree: `deployment/packages/maneline-mmp/install.sh /`
as root installs the same files without a package.

## Setting it up for another repository or name

* Another source: change `url` and `revision` in the `_service` file, and the version
  prefix in `versionformat` to the latest release.
* Another name: rename the spec, `Name:` in it, `pkgname` in the PKGBUILD, `Source:` and
  `Package:` in `debian/control`, the first line of `debian/changelog`, the directory in
  `debian/rules`, and `filename` in `_service`. The installed paths (`/usr/share/maneline-mmp`)
  are in `install.sh` only; a program of the same name as the package is not installed.
* BlueZ: openSUSE Leap 16.0 and 16.1 ship 5.79 and 5.82, which lack the LE bearer interface
  (`org.bluez.Bearer.LE1`, BlueZ 5.84). The OBS project therefore also builds `bluez` for
  Leap, as a link to openSUSE's devel package `Base:System/bluez`, and the RPM requires
  `bluez >= 5.84`. Debian 13 and Raspberry Pi OS 13 ship 5.82 and have no newer build: the
  package installs there (no versioned requirement), but the programs cannot connect.
