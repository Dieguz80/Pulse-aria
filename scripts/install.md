# Installazione manuale e troubleshooting / Manual install and troubleshooting

**🇮🇹** Questa pagina copre installazione manuale, verifica firma, troubleshooting e disinstallazione.  
**🇬🇧** This page covers manual install, signature verification, troubleshooting and uninstall.

Per il quickstart vai al [README principale](../README.md).  
For the quickstart, go to the [main README](../README.md).

---

## Indice / Table of contents

- [Installazione manuale](#installazione-manuale--manual-install)
- [Verifica firma SHA256](#verifica-firma-sha256--sha256-signature-verification)
- [Troubleshooting](#troubleshooting)
  - [Windows SmartScreen](#windows-smartscreen)
  - [macOS Gatekeeper](#macos-gatekeeper)
  - [macOS "App is damaged"](#macos-app-is-damaged)
  - [Microfono non riconosciuto / Microphone not detected](#microfono-non-riconosciuto--microphone-not-detected)
  - [Auto-update non funziona / Auto-update not working](#auto-update-non-funziona--auto-update-not-working)
- [Disinstallazione](#disinstallazione--uninstall)

---

## Installazione manuale / Manual install

### Windows

**🇮🇹**

1. Vai su [github.com/Dieguz80/Pulse-aria/releases/latest](https://github.com/Dieguz80/Pulse-aria/releases/latest)
2. Scarica `pulse-aria-windows.exe` (NSIS, consigliato) oppure `pulse-aria-windows.msi` (enterprise)
3. Doppio click sul file
4. Se appare SmartScreen: "Ulteriori informazioni" → "Esegui comunque"
5. Segui il wizard

**🇬🇧**

1. Go to [github.com/Dieguz80/Pulse-aria/releases/latest](https://github.com/Dieguz80/Pulse-aria/releases/latest)
2. Download `pulse-aria-windows.exe` (NSIS, recommended) or `pulse-aria-windows.msi` (enterprise)
3. Double-click the file
4. If SmartScreen appears: "More info" → "Run anyway"
5. Follow the wizard

### macOS

**🇮🇹**

1. Vai su [github.com/Dieguz80/Pulse-aria/releases/latest](https://github.com/Dieguz80/Pulse-aria/releases/latest)
2. Scarica il file `.dmg` per la tua architettura:
   - **Apple Silicon (M1/M2/M3/M4)**: `pulse-aria-macos-arm64.dmg`
   - **Intel**: `pulse-aria-macos-intel.dmg`

   Per scoprire l'architettura: menu Apple → Informazioni su questo Mac → Chip
3. Apri il `.dmg`, trascina **Pulse-Aria** nella cartella **Applicazioni**
4. Espelli il volume montato
5. Apri Pulse-Aria da Applicazioni (vedi [Gatekeeper](#macos-gatekeeper) per il primo avvio)

**🇬🇧**

1. Go to [github.com/Dieguz80/Pulse-aria/releases/latest](https://github.com/Dieguz80/Pulse-aria/releases/latest)
2. Download the `.dmg` for your architecture:
   - **Apple Silicon (M1/M2/M3/M4)**: `pulse-aria-macos-arm64.dmg`
   - **Intel**: `pulse-aria-macos-intel.dmg`

   To check your architecture: Apple menu → About This Mac → Chip
3. Open the `.dmg`, drag **Pulse-Aria** into the **Applications** folder
4. Eject the mounted volume
5. Open Pulse-Aria from Applications (see [Gatekeeper](#macos-gatekeeper) for first launch)

---

## Verifica firma SHA256 / SHA256 signature verification

**🇮🇹** Ogni release pubblica gli hash SHA256 nelle release notes. Verifica che il file scaricato corrisponda.  
**🇬🇧** Each release publishes SHA256 hashes in release notes. Verify that your downloaded file matches.

### Windows

```powershell
Get-FileHash pulse-aria-windows.exe -Algorithm SHA256
```

### macOS

```bash
shasum -a 256 pulse-aria-macos-*.dmg
```

**🇮🇹** Confronta l'output con l'hash sulla pagina release. Se differisce, NON installare e contatta [hello@pulsare.it](mailto:hello@pulsare.it).  
**🇬🇧** Compare the output with the hash on the release page. If different, DO NOT install and contact [hello@pulsare.it](mailto:hello@pulsare.it).

---

## Troubleshooting

### Windows SmartScreen

**🇮🇹** Errore: "Windows ha protetto il PC".

**Causa**: l'app non è firmata con un certificato EV (in arrivo con v0.6). SmartScreen avvisa per le app nuove o non firmate EV.

**Soluzione**:
1. Clicca "Ulteriori informazioni" nella finestra di avviso
2. Clicca "Esegui comunque"

Apparirà solo al primo avvio dell'installer.

**🇬🇧** Error: "Windows protected your PC".

**Cause**: app is not signed with an EV certificate (coming in v0.6). SmartScreen warns for new or non-EV-signed apps.

**Fix**:
1. Click "More info" in the warning dialog
2. Click "Run anyway"

Will only appear on first installer launch.

---

### macOS Gatekeeper

**🇮🇹** Errore: "Pulse-Aria non può essere aperta perché lo sviluppatore non può essere verificato".

**Causa**: l'app non è firmata con un Apple Developer ID (in arrivo con v0.6). macOS blocca apps non identificate.

**Soluzione**:
1. **Impostazioni di Sistema** → **Privacy e sicurezza**
2. Scorri in fondo, trova: *"Pulse-Aria è stata bloccata dall'apertura perché non proviene da uno sviluppatore identificato"*
3. Clicca **"Apri comunque"**
4. Conferma con la password macOS
5. La prossima volta che apri Pulse-Aria si avvierà direttamente

**🇬🇧** Error: "Pulse-Aria cannot be opened because the developer cannot be verified".

**Cause**: app is not signed with an Apple Developer ID (coming in v0.6). macOS blocks unidentified apps.

**Fix**:
1. **System Settings** → **Privacy & Security**
2. Scroll down, find: *"Pulse-Aria was blocked from use because it is not from an identified developer"*
3. Click **"Open Anyway"**
4. Confirm with your macOS password
5. Next time you open Pulse-Aria it will launch directly

---

### macOS "App is damaged"

**🇮🇹** Errore: "Pulse-Aria è danneggiata e non può essere aperta. Dovresti spostarla nel Cestino."

**Causa**: questo errore appare quando macOS ha aggiunto l'attributo `quarantine` al file scaricato dal browser. Non significa davvero che l'app sia danneggiata.

**Soluzione**:

Apri il Terminale ed esegui:

```bash
xattr -dr com.apple.quarantine "/Applications/Pulse-Aria.app"
```

Poi prova ad aprire di nuovo l'app.

**🇬🇧** Error: "Pulse-Aria is damaged and can't be opened. You should move it to the Trash."

**Cause**: this error appears when macOS adds the `quarantine` attribute to files downloaded from a browser. It doesn't actually mean the app is damaged.

**Fix**:

Open Terminal and run:

```bash
xattr -dr com.apple.quarantine "/Applications/Pulse-Aria.app"
```

Then try opening the app again.

---

### Microfono non riconosciuto / Microphone not detected

**🇮🇹**

1. **Windows**: Impostazioni → Privacy e sicurezza → Microfono → assicurati che "Consenti alle app di accedere al microfono" sia attivo e che Pulse-Aria abbia il permesso
2. **macOS**: Impostazioni di Sistema → Privacy e sicurezza → Microfono → abilita Pulse-Aria
3. Se l'app è in tab Calibrazione mic ma non vede livelli: prova un altro microfono (es. headset USB) per escludere problemi hardware
4. Riavvia Pulse-Aria dopo aver cambiato i permessi

**🇬🇧**

1. **Windows**: Settings → Privacy & security → Microphone → make sure "Let apps access your microphone" is on and Pulse-Aria has permission
2. **macOS**: System Settings → Privacy & Security → Microphone → enable Pulse-Aria
3. If app is in Mic Calibration tab but sees no levels: try a different mic (e.g. USB headset) to rule out hardware
4. Restart Pulse-Aria after changing permissions

---

### Auto-update non funziona / Auto-update not working

**🇮🇹**

L'auto-update controlla all'avvio (silenziosamente). Puoi anche cercare manualmente:

1. Apri Pulse-Aria → **Impostazioni** → **Profilo** → **Cerca aggiornamenti**
2. Se appare "Nessun aggiornamento disponibile" significa che sei già all'ultima versione
3. Se l'aggiornamento fallisce, scarica manualmente l'ultima `.exe`/`.dmg` dalle [release](https://github.com/Dieguz80/Pulse-aria/releases/latest) e reinstalla sopra

**🇬🇧**

Auto-update checks at startup (silently). You can also check manually:

1. Open Pulse-Aria → **Settings** → **Profile** → **Check for updates**
2. "No updates available" means you're already on the latest version
3. If the update fails, manually download the latest `.exe`/`.dmg` from [releases](https://github.com/Dieguz80/Pulse-aria/releases/latest) and reinstall on top

---

## Disinstallazione / Uninstall

### Windows

**🇮🇹**
- Impostazioni → App → trova "Pulse-Aria" → Disinstalla
- Oppure: Pannello di controllo → Programmi e funzionalità

**🇬🇧**
- Settings → Apps → find "Pulse-Aria" → Uninstall
- Or: Control Panel → Programs and Features

### macOS

**🇮🇹**

```bash
# Rimuovi l'app
rm -rf "/Applications/Pulse-Aria.app"

# Rimuovi configurazione (opzionale, perdi tutte le impostazioni)
rm -rf "$HOME/Library/Application Support/Pulse-Aria"
rm -rf "$HOME/Library/Preferences/com.pulsare.pulse-aria.plist"
rm -rf "$HOME/Library/Caches/com.pulsare.pulse-aria"
```

**🇬🇧**

```bash
# Remove the app
rm -rf "/Applications/Pulse-Aria.app"

# Remove configuration (optional, you'll lose all settings)
rm -rf "$HOME/Library/Application Support/Pulse-Aria"
rm -rf "$HOME/Library/Preferences/com.pulsare.pulse-aria.plist"
rm -rf "$HOME/Library/Caches/com.pulsare.pulse-aria"
```

---

## Supporto / Support

**🇮🇹** Se nessuna delle soluzioni qui sopra funziona, [apri una issue](https://github.com/Dieguz80/Pulse-aria/issues) descrivendo:

- Sistema operativo e versione (Windows 11 24H2, macOS 14.5 Sonoma...)
- Architettura (per macOS: Apple Silicon o Intel)
- Versione Pulse-Aria (Impostazioni → Profilo → Informazioni)
- Cosa hai provato a fare
- Cosa è successo / quale errore

**🇬🇧** If none of the above works, [open an issue](https://github.com/Dieguz80/Pulse-aria/issues) describing:

- OS and version (Windows 11 24H2, macOS 14.5 Sonoma...)
- Architecture (for macOS: Apple Silicon or Intel)
- Pulse-Aria version (Settings → Profile → About)
- What you tried to do
- What happened / which error
