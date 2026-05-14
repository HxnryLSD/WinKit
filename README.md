# WinKitV2

Windows maintenance toolkit — two batch scripts for system repair and cleanup.

---

## REPKIT.bat — System Repair

10-step automated repair:

| # | Step | Description |
|---|------|-------------|
| 1 | Driver scan | `pnputil /scan-devices` — re-enumerate hardware |
| 2 | DISM check | `dism /scanhealth` — lightweight image health scan |
| 3 | DISM restore | `dism /restorehealth` — repair corrupt component store |
| 4 | DISM cleanup | `dism /startcomponentcleanup` — shrink WinSxS |
| 5 | SFC | `sfc /scannow` — verify system file integrity |
| 6 | Disk check | `chkdsk C: /f /r` — schedule on next boot |
| 7 | Network reset | `ipconfig /flushdns` + `netsh int ip reset` + `netsh winsock reset` |
| 8 | WU cache reset | stop services, wipe `SoftwareDistribution\Download`, restart |
| 9 | Store cache | kill Store process, delete `LocalCache` |
| 10 | Hibernate off | `powercfg /h off` — frees disk |

**Run as Administrator. Reboot required after chkdsk/SFC.**

---

## FUCKTEMP.bat — Deep Temp Cleaner

10-step cleanup with confirmation prompt:

- Prefetch
- Windows Temp
- Windows Update cache (`SoftwareDistribution\Download`)
- Windows Error Reporting (system + user)
- CBS logs
- User `%TEMP%`
- Browser cache (`INetCache`)
- Recent files
- Crash dumps
- Recycle Bin (`$Recycle.Bin` — all users)

**Run as Administrator.** Data loss risk — reads warning before proceeding.

---

## Requirements

- Windows 10 / 11
- Administrator privileges

---

Discord: hxnrylsd | GitHub: https://github.com/HxnryLSD
